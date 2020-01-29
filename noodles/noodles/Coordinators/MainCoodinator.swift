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
        let vc = FeedViewController(viewModel: viewModel)
        navController.pushViewController(vc, animated: false)
    }

    func presentChannelCreation(push viewController: UIViewController) {
        navController.pushViewController(viewController, animated: true)
    }

    func presentChannelPosts(channelModel: ChannelModel) {
        let interactor = ChannelInteractor(cloudkit: cloudKit, coredata: coreData)
        let viewModel = ChannelViewModel(interactor: interactor, model: channelModel)
         let vc = ChannelViewController(viewModel: viewModel)

        navController.pushViewController(vc, animated: true)
    }

    func presentPost(postModel: PostViewModel) {
        let vc = PresentPostViewController(viewModel: postModel)
        let interactor = PostInteractor(cloudkit: cloudKit, coredata: coreData)
        let viewModel = PostViewModel(interactor: interactor, coordinator: self, model: postModel)
print("Artur")
        // TO DO passar viewModel para data source dessa controller

        navController.pushViewController(vc, animated: true)
    }
}
