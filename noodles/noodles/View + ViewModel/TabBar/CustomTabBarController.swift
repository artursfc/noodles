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
    
    let coordinator: MainCoordinator
    let cloudKit: CloudKitManager
    let coreData: CoreDataManager
    var channelsViewController: ChannelsViewController
    var feedViewController: FeedViewController
//    let searchViewController: SearchViewController
    var saveViewController: SaveViewController
    var profileViewController: ProfileViewController
    
    init(coordinator: MainCoordinator, cloudKit: CloudKitManager, coreData: CoreDataManager) {
        self.coordinator = coordinator
        self.cloudKit = cloudKit
        self.coreData = coreData
        let channelInteractor: ChannelInteractor = ChannelInteractor(cloudkit: cloudKit, coredata: coreData)
        let channelsViewModel: ChannelsViewModel = ChannelsViewModel(interactor: channelInteractor, coordinator: coordinator)
        channelsViewController = ChannelsViewController(viewModel: channelsViewModel)
        
        let postInteractor: PostInteractor = PostInteractor(cloudkit: cloudKit, coredata: coreData)
        let feedViewModel: FeedViewModel = FeedViewModel(interactor: postInteractor, coordinator: coordinator)
        feedViewController = FeedViewController(viewModel: feedViewModel)
        
        saveViewController = SaveViewController(viewModel: feedViewModel)
        
        // Para fazer o search é necessario o SerchViewModel
        
        profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        super.init(nibName: "CustomTabBarController", bundle: nil)
//        setupViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTabBarItens()

//        let controllers = [channelsViewController, feedViewController, searchViewController,
//            saveViewController, profileViewController]
        let controllers = [channelsViewController, feedViewController, saveViewController, profileViewController]

        self.viewControllers = controllers
    }
    /**
     Setup intens on tab bar
     */
    func setupTabBarItens() {

        let channelsIcon = UITabBarItem(title: "", image: UIImage(named: "channelTabBarIcon"), tag: 0)
        let feedIcon = UITabBarItem(title: "", image: UIImage(named: "feedTabBarIcon"), tag: 0)
//        let searchIcon = UITabBarItem(title: "", image: UIImage(named: "searchTabBarIcon"), tag: 0)
        let saveIcon = UITabBarItem(title: "", image: UIImage(named: "saveTabBarIcon"), tag: 0)
        let profileIcon = UITabBarItem(title: "", image: UIImage(named: "profileTabBarIcon"), tag: 0)

        channelsViewController.tabBarItem = channelsIcon
        feedViewController.tabBarItem = feedIcon
//        searchViewController.tabBarItem = searchIcon
        saveViewController.tabBarItem = saveIcon
        profileViewController.tabBarItem = profileIcon
    }
    /**
     Setup the interface of tab bar
     */
    func setup() {
        self.tabBar.isTranslucent = true
        self.tabBar.barTintColor = UIColor.fakeBlack
        self.tabBar.tintColor = UIColor.main
    }
    
//    func setupViewControllers() {
//        let channelInteractor: ChannelInteractor = ChannelInteractor(cloudkit: cloudKit, coredata: coreData)
//        let channelsViewModel: ChannelsViewModel = ChannelsViewModel(interactor: channelInteractor, coordinator: coordinator)
//        channelsViewController = ChannelsViewController(viewModel: channelsViewModel)
//
//        let postInteractor: PostInteractor = PostInteractor(cloudkit: cloudKit, coredata: coreData)
//        let feedViewModel: FeedViewModel = FeedViewModel(interactor: postInteractor, coordinator: coordinator)
//        feedViewController = FeedViewController(viewModel: feedViewModel)
//
//        saveViewController = SaveViewController(viewModel: feedViewModel)
//
//        // Para fazer o search é necessario o SerchViewModel
//
//        profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
//    }
}
