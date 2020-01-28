//
//  FeedViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol FeedViewModelDelegate: class {
    func reloadUI()
}

final class FeedViewModel {
    private let interactor: PostInteractor
    private let coordinator: Coordinator
    private var models = [PostModel]() {
        didSet {
            delegate?.reloadUI()
        }
    }

    weak var delegate: FeedViewModelDelegate?

    init(interactor: PostInteractor, coordinator: Coordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
        fetch()
    }

    public func fetch() {
        interactor.fetchAll(from: .cloudkit) { [weak self] (posts) in
            if let posts = posts {
                DispatchQueue.main.async {
                    self?.models = posts
                }
            }
        }
    }

    public func data(at index: Int) -> PostModel {
        let post = models[index]
        return post
    }

    public func numberOfRows() -> Int {
        return models.count
    }

    public func selected(index: Int) {
        // Coordinator -> Single Post
    }
}
