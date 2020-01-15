//
//  CustomTabBarController.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    let channelsViewController = ChannelsViewController()
    let feedViewController = FeedViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTabBarItens()

        let controllers = [channelsViewController, feedViewController]
        self.viewControllers = controllers
    }

    func setupTabBarItens() {
        let channelsIcon = UITabBarItem(title: "",
                                        image: UIImage(named: "channelTabBarIcon"),
                                        selectedImage: UIImage(named: "channelTabBarIconSelected"))

        channelsViewController.tabBarItem = channelsIcon

        let feedIcon = UITabBarItem(title: "",
                                    image: UIImage(named: "feedTabBarIcon"),
                                    selectedImage: UIImage(named: "feedTabBarIconSelected"))

        feedViewController.tabBarItem = feedIcon
    }

    func setup() {
        self.tabBar.isTranslucent = true
        self.tabBar.barTintColor = UIColor.fakeBlack
        self.tabBar.tintColor = UIColor.main
    }
}
