//
//  ChannelInteractor.swift
//  noodles
//
//  Created by Artur Carneiro on 20/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

final class ChannelInteractor {
    private let cloudkit: CloudKitManager
    private let coredata: CoreDataManager
    private let parser: InteractorParser

    init(cloudkit: CloudKitManager, coredata: CoreDataManager) {
        self.cloudkit = cloudkit
        self.coredata = coredata
        self.parser = InteractorParser()
    }

    // MARK: Public functions
    public func fetch(with channelID: String, from provider: DataProvider, completionHandler: @escaping ((ChannelModel?) -> Void)) {
        switch provider {
        case .cloudkit:
            fetch(with: channelID) { (channel) in
                if let channel = channel {
                    completionHandler(channel)
                } else {
                    completionHandler(nil)
                }
            }
        case .coredata:
            completionHandler(nil)
        }

    }

    public func fetchAll(from provider: DataProvider, completionHandler: @escaping (([ChannelModel]?) -> Void)) {
        switch provider {
        case .cloudkit:
            let query = cloudkit.generateQuery(of: .channels, with: NSPredicate(value: true),
                                               sortedBy: NSSortDescriptor(key: "creationDate", ascending: false))
            cloudkit.query(using: query, on: .publicDB) { [weak self] (response) in
                if response.error != nil {
                    completionHandler(nil)
                } else {
                    if let records = response.records {
                        let channelModels = self?.parser.parse(records: records, into: .channels)
                        if let channels = channelModels as? [ChannelModel] {
                            completionHandler(channels)
                        }

                    }
                }
            }
        case .coredata:
            completionHandler(nil)
        }
    }

    public func save(channel: ChannelModel, completionHandler: @escaping ((Bool) -> Void)) {
        let models = [channel]
        let records = parser.parse(models: models, of: .channels)
        if records.isEmpty {
            completionHandler(false)
        }
        if let record = records.first {
            cloudkit.save(record: record, on: .publicDB) { (response) in
                if response.error == nil && response.records == nil {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }

    public func update(channel: ChannelModel, with newChannel: ChannelModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: channel.id)
        let models = [newChannel]
        let records = parser.parse(models: models, of: .channels)
        if records.isEmpty {
            completionHandler(false)
        }
        if let record = records.first {
            cloudkit.update(recordID: recordID, with: record, on: .publicDB) { (response) in
                if response.error == nil && response.records == nil {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }

    public func delete(channel: ChannelModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: channel.id)
        cloudkit.delete(recordID: recordID, on: .publicDB) { (response) in
            if response.error == nil && response.records == nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    // MARK: Private functions

    private func fetch(with channelID: String, completionHandler: @escaping ((ChannelModel?) -> Void)) {
        let recordID = CKRecord.ID(recordName: channelID)
        cloudkit.fetch(recordID: recordID, on: .publicDB) { [weak self] (response) in
            if response.error == nil {
                guard let record = response.records?.first else {
                    return
                }
                var channel = ChannelModel(id: channelID, name: record["name"] ?? "", posts: nil, createdBy: nil,
                                           canBeEditedBy: nil, canBeViewedBy: nil, createdAt: record["createdAt"] ?? nil,
                                           editedAt: record["modifiedAt"] ?? nil)
                let group = DispatchGroup()
                if let postsRef = record["posts"] as? [CKRecord.Reference] {
                    var postsID = [CKRecord.ID]()
                    for postRef in postsRef {
                        postsID.append(postRef.recordID)
                    }
                    group.enter()
                    self?.cloudkit.fetchReferences(of: postsID, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let records = response.records {
                            let postsModels = self?.parser.parse(records: records, into: .posts)
                            if let posts = postsModels as? [PostModel] {
                                channel.posts = posts
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                }
                if let beViewedRefs = record["canBeViewedBy"] as? [CKRecord.Reference] {
                    var beViewedIDs = [CKRecord.ID]()
                    for beViewed in beViewedRefs {
                        beViewedIDs.append(beViewed.recordID)
                    }
                    group.enter()
                    self?.cloudkit.fetchReferences(of: beViewedIDs, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let records = response.records {
                            let rankModels = self?.parser.parse(records: records, into: .ranks)
                            if let ranks = rankModels as? [RankModel] {
                                channel.canBeViewedBy = ranks
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                    }
                if let beEditedRefs = record["canBeEditedBy"] as? [CKRecord.Reference] {
                    var beEditedIDs = [CKRecord.ID]()
                    for beEdited in beEditedRefs {
                        beEditedIDs.append(beEdited.recordID)
                    }
                    group.enter()
                    self?.cloudkit.fetchReferences(of: beEditedIDs, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let records = response.records {
                            let rankModels = self?.parser.parse(records: records, into: .ranks)
                            if let ranks = rankModels as? [RankModel] {
                                channel.canBeEditedBy = ranks
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                    }
                if let createdByRef = record.creatorUserRecordID {
                    group.enter()
                    self?.cloudkit.fetch(recordID: createdByRef, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let record = response.records {
                            let usersModel = self?.parser.parse(records: record, into: .users)
                            if let user = usersModel?.first as? UserModel {
                                channel.createdBy = user
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                }
                group.notify(queue: .main) {
                    completionHandler(channel)
                }
            } else {
                completionHandler(nil)
            }
        }
    }

}
