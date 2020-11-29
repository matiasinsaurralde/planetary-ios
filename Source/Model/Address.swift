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
struct SSBAddress: Codable {
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
    let SSBAddress: String // multiserver

    let InUse: Bool
    let WorkedLast: String
    let LastError: String
    let redeemed: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.AddressID)
    }
}

typealias KnownPubs = [KnownPub]

