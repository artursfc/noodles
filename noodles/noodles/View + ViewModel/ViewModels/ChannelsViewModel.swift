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

final class ChannelsViewModel: ViewModel {
    private let interactor: ChannelInteractor
    private let coordinator: MainCoordinator
    private var models = [ChannelModel]() {
        didSet {
            delegate?.reloadUI()
        }
    }

    weak var delegate: ChannelsViewModelDelegate?

    init(interactor: ChannelInteractor, coordinator: MainCoordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
    }

    // MARK: Public functions
    // fetch() should be used for pull-to-refresh
    public func fetch() {
        interactor.fetchAll(from: .cloudkit) { [weak self] (channels) in
            if let channels = channels {
                DispatchQueue.main.async {
                    self?.models = channels
                }
            }
        }
    }

    public func name(at index: Int) -> String {
        return models[index].name
    }

    /*
    The public functions below are all to be used by the view to either build the
    layout or respond to the user's input
    */
    public func numberOfSections() -> Int {
        return models.count
    }

    /*
     Use this function to get the ChannelModel chosen by the user. The returning model should be
     used by the function in the View that asks the Coordinator for the next screen
    */
    public func selected(at index: Int) {
        coordinator.presentChannel(channelModel: models[index])
    }
}
