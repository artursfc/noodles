//
//  ChannelsViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol ChannelsViewModelDelegate: class {
    func reloadUI()
}

final class ChannelsViewModel {
    private let interactor: ChannelInteractor
    private let coordinator: Coordinator
    private var models = [ChannelModel]()

    weak var delegate: ChannelsViewModelDelegate?

    init(interactor: ChannelInteractor, coordinator: Coordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
        fetch()
    }

    public func fetch() {
        interactor.fetchAll(from: .cloudkit) { [weak self] (channels) in
            if let channels = channels {
                DispatchQueue.main.async {
                    self?.models = channels
                }
            }
        }
    }

    public func data(at index: Int) -> ChannelModel {
        let channel = models[index]
        return channel
    }

    public func numberOfSections() -> Int {
        return models.count
    }

    public func selected(index: Int) {
        // Coordinator -> Single Post
    }
}
