//
//  PostsViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol PostViewModelDelegate: class {
    func reloadUI()
}

final class PostViewModel {
    private let interactor: PostInteractor
    private let coordinator: Coordinator
    private var model: PostModel {
        didSet {
            delegate?.reloadUI()
        }
    }

    weak var delegate: PostViewModelDelegate?

    init(interactor: PostInteractor, coordinator: Coordinator, model: PostModel) {
        self.interactor = interactor
        self.coordinator = coordinator
        self.model = model
    }
    
}
