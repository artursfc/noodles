//
//  CustomTabBarController.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {

    let channelsViewController = ChannelsViewController()
    let feedViewController = FeedViewController(viewModel: nil)
    let searchViewController = SearchViewController()
    let saveViewController = SaveViewController()
    let profileViewController = ProfileViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTabBarItens()

        let controllers = [channelsViewController, feedViewController, searchViewController,
            saveViewController, profileViewController]

        self.viewControllers = controllers
    }

    func setupTabBarItens() {

        let channelsIcon = UITabBarItem(title: "", image: UIImage(named: "channelTabBarIcon"), tag: 0)
        let feedIcon = UITabBarItem(title: "", image: UIImage(named: "feedTabBarIcon"), tag: 0)
        let searchIcon = UITabBarItem(title: "", image: UIImage(named: "searchTabBarIcon"), tag: 0)
        let saveIcon = UITabBarItem(title: "", image: UIImage(named: "saveTabBarIcon"), tag: 0)
        let profileIcon = UITabBarItem(title: "", image: UIImage(named: "profileTabBarIcon"), tag: 0)

        channelsViewController.tabBarItem = channelsIcon
        feedViewController.tabBarItem = feedIcon
        searchViewController.tabBarItem = searchIcon
        saveViewController.tabBarItem = saveIcon
        profileViewController.tabBarItem = profileIcon
    }

    func setup() {
        self.tabBar.isTranslucent = true
        self.tabBar.barTintColor = UIColor.fakeBlack
        self.tabBar.tintColor = UIColor.main
    }
}
