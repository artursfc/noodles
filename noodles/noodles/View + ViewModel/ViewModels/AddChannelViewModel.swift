//
//  AddChannelViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 27/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

enum AddChannelField {
    case name
    case channel
}

protocol AddChannelViewModelDelegate: class {
    func reject(field: AddChannelField)
    func accept(field: AddChannelField)
}

final class AddChannelViewModel {
    private let channelInteractor: ChannelInteractor
    private let rankInteractor: RankInteractor
    private var ranks = [RankModel]()

    weak var delegate: AddChannelViewModelDelegate?

    init(channelInteractor: ChannelInteractor, rankInteractor: RankInteractor) {
        self.channelInteractor = channelInteractor
        self.rankInteractor = rankInteractor
        self.ranks = fetchRanks() ?? []
    }

    // MARK: Public attributes
    public var name: String = ""

    // ID of Ranks that can edit the channel
    public var canBeEditedBy = [String]()

    // ID of Ranks that can view the channel
    public var canBeViewedBy = [String]()

    // MARK: Private attributes
    private var createdBy: String = ""

    // MARK: Public functions
    public func rankNames() -> [(String, String)] {
        var result = [(String, String)]()
        if !ranks.isEmpty {
            for rank in ranks {
                result.append((rank.id, rank.title))
            }
        }
        return result
    }

    public func create() {
        if !name.isEmpty && !canBeEditedBy.isEmpty && !canBeViewedBy.isEmpty {
            channelInteractor.isTaken(name: name) { [weak self] (bool) in
                guard let self = self else {
                    return
                }
                if bool {
                    self.delegate?.reject(field: .name)
                } else {
                    self.delegate?.accept(field: .channel)
                }
            }
        } else {
            delegate?.reject(field: .channel)
        }
    }

    // MARK: Private functions
    private func fetchRanks() -> [RankModel]? {
        var result = [RankModel]()
        rankInteractor.fetchAll(from: .cloudkit) { (ranks) in
            if let ranks = ranks {
                result = ranks
            }
        }
        return result
    }
}
