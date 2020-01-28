//
//  ChannelCreationCoordinator.swift
//  noodles
//
//  Created by Eloisa Falcão on 27/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {

    var navController: UINavigationController
    let cloudKit: CloudKitManager
    let coreData: CoreDataManager

    init(navController: UINavigationController) {
        self.navController = navController
        cloudKit = CloudKitManager()
        coreData = CoreDataManager()
    }

    func start() {

        let interactor = PostInteractor(cloudkit: cloudKit, coredata: coreData)
        let viewModel = FeedViewModel(interactor: interactor)

        let channelCreationViewController = ChannelCreationViewController()
        navController.pushViewController(channelCreationViewController, animated: true)
    }

    func back(dismiss viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func presentChannelCreation(push viewController: UIViewController) {
        navController.pushViewController(viewController, animated: true)
    }

    func presentChannelPosts(push viewController: UIViewController, with channel: ChannelViewModel) {
         navController.pushViewController(viewController, animated: true)
    }
}
