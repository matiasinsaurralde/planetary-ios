//
//  Address.swift
//  FBTT
//
//  Created by Henry Bubert on 02.04.19.
//  Copyright © 2019 Verse Communications Inc. All rights reserved.
//

import Foundation

import OpenSslKit

// new pub/peer advertisments
// address is multiserver encoded like net:10.10.0.1:8008~shs:pybKey=
// but only go bot has to deal with that.
// just using sqlite the datastore for enable/worked
struct Address: Codable {
    let type: ContentType
    let address: String
    let availability: Double
    
    public let raw: Data

    public init(raw: Data, type: ContentType?, address: String?, availability: Double?) {
        self.raw = raw
        self.type = type ?? .walletAddress
        self.address = address ?? ""
        self.availability = availability ?? 0
    }

    public init(hex: String, type: ContentType?, address: String?, availability: Double?) throws {
        self.type = type ?? .walletAddress
        self.address = address ?? ""
        self.availability = availability ?? 0

        try Address.validate(address: hex)

        guard let data = Data(hex: hex) else {
            throw ValidationError.invalidHex
        }

        raw = data
    }

    public var hex: String {
        raw.toHexString()
    }

    public var eip55: String {
        EIP55.format(address: raw.hex)
    }
}


struct Pub: ContentCodable {
    let type: ContentType
    let address: PubAddress
}

struct PubAddress: Codable {
    let key: Identifier
    let host: String
    let port: UInt
    
    var multipeer: String {
        return "net:\(self.host):\(self.port)~shs:\(self.key.id)"
    }
    
    func toPeer() -> Peer {
        return Peer(tcpAddr: "\(self.host):\(self.port)", pubKey: self.key)
    }
    
}

struct KnownPub: Hashable {
    let AddressID: Int64

    let ForFeed: Identifier
    let Address: String // multiserver

    let InUse: Bool
    let WorkedLast: String
    let LastError: String
    let redeemed: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.AddressID)
    }
}

typealias KnownPubs = [KnownPub]



extension Address {

    private static func character(_ str: String, _ i: Int) -> String {
        String(str[str.index(str.startIndex, offsetBy: i)])
    }

    private static func isCheckSumAddress(hex: String) throws {
        let addressHash: String = OpenSslKit.Kit.sha3(hex.lowercased().data(using: .ascii)!).hex
        for i in 0..<40 {
            let hashSymbol = character(addressHash, i)

            guard let int = Int(hashSymbol, radix: 16) else {
                throw ValidationError.invalidSymbols
            }
            if (int > 7 && character(hex, i).uppercased() != character(hex, i)) || (int < 8 && character(hex, i).lowercased() != character(hex, i)) {
                throw ValidationError.invalidChecksum
            }
        }
    }

    private static func validate(address: String) throws {
        guard address.hasPrefix("0x") else {
            throw ValidationError.wrongAddressPrefix
        }
        let hex = String(address.dropFirst(2))
        guard hex.count == 40 else {
            throw ValidationError.invalidAddressLength
        }
        let decimalDigits = CharacterSet.decimalDigits
        let lowerCasedHex = decimalDigits.union(CharacterSet(charactersIn: "abcdef"))
        let upperCasedHex = decimalDigits.union(CharacterSet(charactersIn: "ABCDEF"))
        let mixedHex = decimalDigits.union(CharacterSet(charactersIn: "abcdefABCDEF"))
        guard mixedHex.isSuperset(of: CharacterSet(charactersIn: hex)) else {
            throw ValidationError.invalidSymbols
        }
        if lowerCasedHex.isSuperset(of: CharacterSet(charactersIn: hex)) || upperCasedHex.isSuperset(of: CharacterSet(charactersIn: hex)) {
            return
        } else {
            try isCheckSumAddress(hex: hex)
        }
    }

}

extension Address: CustomStringConvertible {

    public var description: String {
        hex
    }

}

extension Address: Equatable {

    public static func ==(lhs: Address, rhs: Address) -> Bool {
        lhs.raw == rhs.raw
    }

}

extension Address {

    public enum ValidationError: Error {
        case invalidHex
        case invalidChecksum
        case invalidAddressLength
        case invalidSymbols
        case wrongAddressPrefix
    }

}
