//
//  AboutView.swift
//  FBTT
//
//  Created by Rabble on 11/26/20.
//  Copyright © 2019 Verse Communications Inc. All rights reserved.
//



import Foundation
import UIKit


class WalletView: UIView {

    //slet profileView = ProfileImageView()

    let label: UILabel = {
        let view = UILabel.forAutoLayout()
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.textAlignment = .center
        view.textColor = UIColor.text.default
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    let signMesageButton = WalletButton(title: .yourProfile, image: UIImage.verse.profile)
    let signTransactionButton = WalletButton(title: .yourWallet, image: UIImage.verse.profile)
    let payWithTrustButton = WalletButton(title: .settings, image: UIImage.verse.settings)
    let getAccountsButton = WalletButton(title: .helpAndSupport, image: UIImage.verse.help)
    let signSimpleTxButton = WalletButton(title: .reportBug, image: UIImage.verse.reportBug)

    let peersView = PeersView()
    

    override init(frame: CGRect) {

        super.init(frame: frame)
        self.backgroundColor = UIColor.menuBackgroundColor

        //self.addSubview(self.profileView)
        
        //Layout.fillSouth(of: self.profileView, with: self.label, insets: UIEdgeInsets(top: 20, left: Layout.horizontalSpacing, bottom: 0, right: -Layout.horizontalSpacing))

        var separator = Layout.separatorView(color: UIColor.menuBorderColor)
        
        //Layout.fillSouth(of: self.label, with: separator, insets: .top(60))

        Layout.fillSouth(of: separator, with: self.signMesageButton)
        self.signMesageButton.constrainHeight(to: 50)
        self.signMesageButton.imageEdgeInsets = .top(-5)
        
        separator = Layout.separatorView(color: UIColor.menuBorderColor)
        //Layout.fillSouth(of: self.profileButton, with: separator)
        
        //Layout.fillSouth(of: separator, with: self.walletButton)
        self.signTransactionButton.constrainHeight(to: 50)
        self.signTransactionButton.imageEdgeInsets = .top(-5)
        
        separator = Layout.separatorView(color: UIColor.menuBorderColor)
        //Layout.fillSouth(of: self.walletButton, with: separator)

        //Layout.fillSouth(of: separator, with: self.settingsButton)
        self.payWithTrustButton.constrainHeight(to: 50)
        
        separator = Layout.separatorView(color: UIColor.menuBorderColor)
        //Layout.fillSouth(of: self.settingsButton, with: separator)

        //Layout.fillSouth(of: separator, with: self.helpButton)
        self.getAccountsButton.constrainHeight(to: 50)
        self.getAccountsButton.imageEdgeInsets = .top(2)
        
        separator = Layout.separatorView(color: UIColor.menuBorderColor)
        //Layout.fillSouth(of: self.helpButton, with: separator)

        //Layout.fillSouth(of: separator, with: self.reportBugButton)
        self.signSimpleTxButton.constrainHeight(to: 50)
        
        separator = Layout.separatorView(color: UIColor.menuBorderColor)
        //Layout.fillSouth(of: self.reportBugButton, with: separator)

        let insets = UIEdgeInsets(top: 0, left: self.signSimpleTxButton.contentEdgeInsets.left + 8, bottom: -36, right: -Layout.horizontalSpacing)
        Layout.fillBottom(of: self, with: self.peersView, insets: insets)
        self.peersView.isHidden = !UserDefaults.standard.showPeerToPeerWidget
        self.peersView.layoutSubviews()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class WalletButton: UIButton {

    init(title: Text, image: UIImage? = nil) {

        super.init(frame: .zero)
        self.contentHorizontalAlignment = .left
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 0)

        self.setTitle(title.text, for: .normal)
        self.setTitleColor(UIColor.menuUnselectedItemText, for: .normal)
        self.setTitleColor(UIColor.menuSelectedItemText, for: .highlighted)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        self.setImage(image, for: .normal)

        self.setBackgroundImage(UIColor.menuSelectedItemBackground.image(), for: .highlighted)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
