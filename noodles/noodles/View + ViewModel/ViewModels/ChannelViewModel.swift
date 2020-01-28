//
//  ChannelViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol ChannelViewModelDelegate: class {
    func reloadUI()
}

final class ChannelViewModel {
    private let interactor: ChannelInteractor
    private var model: ChannelModel {
        didSet {
            delegate?.reloadUI()
        }
    }

    weak var delegate: ChannelsViewModelDelegate?

    init(interactor: ChannelInteractor, model: ChannelModel) {
        self.interactor = interactor
        self.model = model
    }

    public func fetch() {
        interactor.fetch(with: model.id, from: .cloudkit) { [weak self] (channel) in
            if let channel = channel {
                DispatchQueue.main.async {
                    self?.model = channel
                }
            }
        }
    }

    public func data(at index: Int) -> PostModel? {
        if let post = model.posts?[index] {
            return post
        }
        return nil
    }

    public func numberOfRows() -> Int {
        return model.posts?.count ?? 0
    }

    public func selected(index: Int) {
        // Coordinator -> Single Post from Channel
    }
}
