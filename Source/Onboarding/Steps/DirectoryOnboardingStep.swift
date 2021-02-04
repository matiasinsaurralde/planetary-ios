//
//  DirectoryOnboardingStep.swift
//  FBTT
//
//  Created by Christoph on 7/16/19.
//  Copyright © 2019 Verse Communications Inc. All rights reserved.
//

import Foundation
import UIKit

class DirectoryOnboardingStep: OnboardingStep, UITableViewDataSource, UITableViewDelegate {

    private lazy var tableView: UITableView = {
        let view = UITableView.forVerse()
        view.dataSource = self
        view.delegate = self
        view.separatorColor = UIColor.separator.middle
        view.allowsSelection = false
        return view
    }()

    private var stars = [Star]()
    private var abouts = [About]()

    init() {
        super.init(.directory)
        self.showsNavigationBar = true
    }

    override func customizeView() {
        self.view.titleLabel.isHidden = true

        let topSeparator = Layout.addSeparator(toTopOf: self.view)

        let bottomSeparator = Layout.separatorView()
        Layout.fillNorth(of: self.view.buttonStack, with: bottomSeparator)

        Layout.fillSouth(of: topSeparator, with: self.tableView)
        self.tableView.pinBottom(toTopOf: bottomSeparator)

        self.view.primaryButton.isHidden = true
    }

    override func customizeController(controller: ContentViewController) {
        let nextButton = UIBarButtonItem(title: Text.next.text, style: .plain, target: self, action: #selector(didPressNext))
        controller.navigationItem.rightBarButtonItem = nextButton
        controller.navigationItem.hidesBackButton = true
    }

    override func didStart() {
        self.view.lookBusy()
        let identities = Environment.Communities.stars.map({$0.feed})
        Bots.current.abouts(identities: identities) { [weak self] (abouts, error) in
            self?.stars = Environment.Communities.stars
            self?.abouts = abouts
            self?.tableView.reloadData()
            self?.view.lookReady()
        }
    }

    @objc func didPressNext() {
        self.primary()
    }

    override func primary() {
        self.next()
    }

    // MARK: table stuff

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.className) as? CommunityTableViewCell ?? CommunityTableViewCell()
        let star = self.stars[indexPath.row]
        let about = self.abouts.first(where:{$0.identity == star.feed})
        cell.communityView.update(with: star, about: about)
        return cell
    }
    
}
