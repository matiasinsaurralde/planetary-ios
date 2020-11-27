//
//  WalletViewController.swift
//  Planetary
//
//  Created by Rabble on 11/26/20.
//  Copyright © 2020 Verse Communications Inc. All rights reserved.
//


import UIKit
import BigInt
import TrustSDK
import CryptoSwift
import WalletCore

class WalletViewController: UIViewController {
    @IBOutlet weak var signMesageButton: TrustButton!
    @IBOutlet weak var signTransactionButton: TrustButton!
    @IBOutlet weak var payWithTrustButton: TrustButton!
    @IBOutlet weak var getAccountsButton: TrustButton!
    @IBOutlet weak var signSimpleTxButton: UIButton!

    let meta = TrustSDK.SignMetadata.dApp(name: "Test", url: URL(string: "https://dapptest.com"))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignTransactionButton()
        setupSignMessageButton()
        setupGetAccountsButton()
        setupPayWithTrustButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupSignMessageButton() {
        let data = Data("Some message".utf8)
        let message = Data("\u{19}Ethereum Signed Message:\n\(data.count)".utf8) + data
        let hash = message.sha3(.keccak256)

        //signMesageButton.apply(theme: TrustButtonTheme
        //    .blue
        //    .with(styles: .title(.plain("Sign Message")), .icon(.trust), .roundFull)
        //)

        signMesageButton.action = .signMessage(hash) { result in
            switch result {
            case .success(let signature):
                let alert = UIAlertController(
                    title: "Signature",
                    message: signature,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failure(let error):
                print("Failed to sign: \(error)")
            }
        }
    }

    func setupSignTransactionButton() {
        let input = EthereumSigningInput.with {
            $0.toAddress = "0x728B02377230b5df73Aa4E3192E89b6090DD7312"
            $0.chainID = BigInt("1").serialize()!
            $0.nonce = BigInt("477").serialize()!
            $0.gasPrice = BigInt("2112000000").serialize()!
            $0.gasLimit = BigInt("21000").serialize()!
            $0.amount = BigInt("100000000000000").serialize()!
        }

        //signTransactionButton.apply(theme: TrustButtonTheme
        //    .white
        //    .with(styles: .title(.plain("Sign Transaction")), .icon(.trust))
        //)
        
        let signer = TrustSDK.signers.ethereum
        let metadatas = meta
        
        /*
        signTransactionButton.action = .sign(signer: signer, input: input, metadata: metadatas) { result in
            
            switch result {
            case .success(let output):
                /*
                let alert = UIAlertController(
                    title: "Transaction",
                    message: output.map({ String(format: "%02x", $0) }).joined(),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                */
                print("Suceeded to sign: \(output)")
            case .failure(let error):
                print("Failed to sign: \(error)")
            }
            
        }
    */
    }

    @IBAction func signSimpleEthTx(sender: UIButton) {
        let tx = TrustSDK.Transaction(
            asset: UniversalAssetID(coin: .ethereum, token: ""),
            to: "0x728B02377230b5df73Aa4E3192E89b6090DD7312",
            amount: "0.01",
            action: .transfer,
            confirm: .sign,
            from: nil,
            nonce: 447,
            feePrice: "2112000000",
            feeLimit: "21000"
        )
        TrustSDK.Signer(coin: .ethereum).sign(tx) { result in
            print(result)
        }
    }

    func setupPayWithTrustButton() {
        let input = EthereumSigningInput.with {
            $0.toAddress = "0x728B02377230b5df73Aa4E3192E89b6090DD7312"
            $0.chainID = BigInt("1").serialize()!
            $0.amount = BigInt("100000000000000").serialize()!
        }

        payWithTrustButton.apply(theme: TrustButtonTheme
            .black
            .with(styles: .title(.payWithTrust(icon: .shieldLined)))
        )

        payWithTrustButton.action = .signThenSend(signer: TrustSDK.signers.ethereum, input: input, metadata: meta) { (result) in
            switch result {
            case .success(let output):
                let alert = UIAlertController(
                    title: "Transaction Hash",
                    message: output,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failure(let error):
                print("Failed to sign: \(error)")
            }
        }
    }

    func setupGetAccountsButton() {
        getAccountsButton.apply(theme: TrustButtonTheme
            .white
            .with(styles: .title(.plain("Get Accounts")), .icon(.trust), .roundFull)
        )

        getAccountsButton.action = .getAccounts(coins: [.ethereum, .binance]) { result in
            switch result {
            case .success(let addresses):
                let alert = UIAlertController(
                    title: "Address",
                    message: addresses.joined(separator: ", "),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failure(let error):
                print("Failed to get addresses: \(error)")
            }
        }
    }
}


/*
class WalletViewController: UITableViewController {

    //@IBOutlet weak var signMesageButton: TrustButton!
    //@IBOutlet weak var signTransactionButton: TrustButton!
    //@IBOutlet weak var payWithTrustButton: TrustButton!
    //@IBOutlet weak var getAccountsButton: TrustButton!
    //@IBOutlet weak var signSimpleTxButton: UIButton!

    let meta = TrustSDK.SignMetadata.dApp(name: "Test", url: URL(string: "https://dapptest.com"))

    // lazy var walletView: UIView = {
    //    let view = UIView()
    // }
    
        
        //private let walletView: WalletView = {
       // let view = waletView.forAutoLayout()
       // view.transform = CGAffineTransform(translationX: -300, y: 0)
       // return vie
    //s}()

     lazy var closeButton: UIButton = {
        let button = UIButton.forAutoLayout()
        button.addTarget(self, action: #selector(closeButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

     let backgroundView: UIView = {
        let view = UIView.forAutoLayout()
        view.alpha = 0
        view.backgroundColor = UIColor.screenOverlay
        return view
    }()

    private lazy var walletView: WalletView = {
        let view = WalletView()
        return view
    }()

    @objc  func closeButtonTouchUpInside() {
        //self.close()
    }

    override func viewDidLoad() {
        //super.viewDidLoad()
        Layout.fill(view: self.backgroundView, with: self.walletView, respectSafeArea: false)
        
        
        
        setupSignTransactionButton()
        setupSignMessageButton()
        setupGetAccountsButton()
        setupPayWithTrustButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        CrashReporting.shared.record("Did Show About")
        Analytics.shared.trackDidShowScreen(screenName: "about")
    }
    
    override func didReceiveMemoryWarning() {
        //super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func setupSignMessageButton() {
        let data = Data("Some message".utf8)
        let message = Data("\u{19}Ethereum Signed Message:\n\(data.count)".utf8) + data
        let hash = message.sha3(.keccak256)
        
        
        
        
        /*
        signMesageButton.apply(theme: TrustButtonTheme
            .blue
            .with(styles: .title(.plain("Sign Message")), .icon(.trust), .roundFull)
        )

        signMesageButton.action = .signMessage(hash) { result in
            switch result {
            case .success(let signature):
                let alert = UIAlertController(
                    title: "Signature",
                    message: signature,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failure(let error):
                print("Failed to sign: \(error)")
            }
        }
 */
    }
    
    
    @objc private func signupButtonTouchUpInside() {
        Analytics.shared.trackDidTapButton(buttonName: "wallet")
        self.close() {
            AppController.shared.showWalletViewController()
        }
    }


    func setupSignTransactionButton() {
        let input = EthereumSigningInput.with {
            $0.toAddress = "0x728B02377230b5df73Aa4E3192E89b6090DD7312"
            $0.chainID = BigInt("1").serialize()!
            $0.nonce = BigInt("477").serialize()!
            $0.gasPrice = BigInt("2112000000").serialize()!
            $0.gasLimit = BigInt("21000").serialize()!
            $0.amount = BigInt("100000000000000").serialize()!
        }
        /*
        signTransactionButton.apply(theme: TrustButtonTheme
            .white
            .with(styles: .title(.plain("Sign Transaction")), .icon(.trust))
        )

        signTransactionButton.action = .sign(signer: TrustSDK.signers.ethereum, input: input, metadata: meta) { result in
            switch result {
            case .success(let output):
                let alert = UIAlertController(
                    title: "Transaction",
                    message: output.map({ String(format: "%02x", $0) }).joined(),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failure(let error):
                print("Failed to sign: \(error)")
            }
        }
        */
    }

    @IBAction func signSimpleEthTx(sender: UIButton) {
        let tx = TrustSDK.Transaction(
            asset: UniversalAssetID(coin: .ethereum, token: ""),
            to: "0x728B02377230b5df73Aa4E3192E89b6090DD7312",
            amount: "0.01",
            action: .transfer,
            confirm: .sign,
            from: nil,
            nonce: 447,
            feePrice: "2112000000",
            feeLimit: "21000"
        )
        TrustSDK.Signer(coin: .ethereum).sign(tx) { result in
            print(result)
        }
    }

    func setupPayWithTrustButton() {
        let input = EthereumSigningInput.with {
            $0.toAddress = "0x728B02377230b5df73Aa4E3192E89b6090DD7312"
            $0.chainID = BigInt("1").serialize()!
            $0.amount = BigInt("100000000000000").serialize()!
        }
        
        /*
        payWithTrustButton.apply(theme: TrustButtonTheme
            .black
            .with(styles: .title(.payWithTrust(icon: .shieldLined)))
        )

        payWithTrustButton.action = .signThenSend(signer: TrustSDK.signers.ethereum, input: input, metadata: meta) { (result) in
            switch result {
            case .success(let output):
                let alert = UIAlertController(
                    title: "Transaction Hash",
                    message: output,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failure(let error):
                print("Failed to sign: \(error)")
            }
        }
         */
    }

    func setupGetAccountsButton() {
        /*
        getAccountsButton.apply(theme: TrustButtonTheme
            .white
            .with(styles: .title(.plain("Get Accounts")), .icon(.trust), .roundFull)
        )

        getAccountsButton.action = .getAccounts(coins: [.ethereum, .binance]) { result in
            switch result {
            case .success(let addresses):
                let alert = UIAlertController(
                    title: "Address",
                    message: addresses.joined(separator: ", "),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failure(let error):
                print("Failed to get addresses: \(error)")
            }
        }*/
    }
    
    
    // MARK: Animations

    func open(animated: Bool = true) {

        UIView.animate(withDuration: animated ? 0.2 : 0,
                       delay: 0,
                       options: .curveEaseOut,
                       animations:
            {
                self.backgroundView.alpha = 1
                //self.menuView.transform = CGAffineTransform.identity
            },
                       completion: nil)
    }

    func close(animated: Bool = true, completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: animated ? 0.2 : 0,
                       delay: 0,
                       options: .curveEaseIn,
                       animations:
            {
                self.backgroundView.alpha = 0
                //self.menuView.transform = CGAffineTransform(translationX: -300, y: 0)
            },
                       completion:
            {
                finished in
                self.dismiss(animated: false) { completion?() }
            })
    }
}


*/
