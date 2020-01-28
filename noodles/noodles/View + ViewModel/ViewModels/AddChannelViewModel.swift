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
    func saved()
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

    // Chosen index of ranks array
    public var canBeEditedBy = [Int]()

    // Chosen index of ranks array
    public var canBeViewedBy = [Int]()

    // MARK: Private attributes
    private var createdBy: String = ""

    // MARK: Public functions
    public func rankNames(at index: Int) -> String {
        if !ranks.isEmpty {
            return ranks[index].title
        }
        return ""
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
                    var channel = ChannelModel(id: "", name: self.name, posts: nil,
                                               createdBy: nil, canBeEditedBy: nil, canBeViewedBy: nil,
                                               createdAt: nil, editedAt: nil)

                    var beEditedByArr = [RankModel]()
                    for index in self.canBeEditedBy {
                        beEditedByArr.append(self.ranks[index])
                    }
                    channel.canBeEditedBy = beEditedByArr

                    var beViewedByArr = [RankModel]()
                    for index in self.canBeViewedBy {
                        beViewedByArr.append(self.ranks[index])
                    }
                    channel.canBeViewedBy = beViewedByArr

                    self.channelInteractor.save(channel: channel) { (bool) in
                        if bool {
                            self.delegate?.saved()
                        }
                    }
                }
            }
        } else {
            delegate?.reject(field: .channel)
        }
    }

    public func ranksNumberOfRows() -> Int {
        return ranks.count
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
