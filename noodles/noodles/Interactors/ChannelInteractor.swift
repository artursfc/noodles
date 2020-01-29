//
//  ChannelInteractor.swift
//  noodles
//
//  Created by Artur Carneiro on 20/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

/**
 Interactor used by Channel-related ViewModels to connect with Core Data and CloudKit through a common struct(ChannelModel).
 */
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
    /**
     Fetches a channel from a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - channelID: A channel's ID as a string.
        - provider: Enum used to determine from which Data Provider to fetch data.
        - completionHandler: Returns a ChannelModel as the result of the async function.
     */
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

    /**
     Fetches all channels from a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - provider: Enum used to determine from which Data Provider to fetch data.
        - completionHandler: Returns an array of ChannelModel as the result of the async function.
     */
    public func fetchAll(from provider: DataProvider, completionHandler: @escaping (([ChannelModel]?) -> Void)) {
        switch provider {
        case .cloudkit:
            let defaults = UserDefaults.standard
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

    /**
     Saves a channel on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - channel: A ChannelModel that will be saved as CKRecord.
        - completionHandler: Returns a Bool as the result of the async function.
     */
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

    /**
     Updates a channel on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - channel: A ChannelModel that will be updated.
        - newChannel: A ChannelModel that will be used to update the channel.
        - completionHandler: Returns a Bool as the result of the async function.
     */
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

    /**
     Deletes a channel on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - channel: A ChannelModel that will be deleted.
        - completionHandler: Returns a Bool as the result of the async function.
     */
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

    /**
     Checks the availability of a given name. Async function.
     - Parameters:
        - name: A name that will be checked for availability against CloudKit's public database.
        - completionHandler: Returns a Bool as the result of the async function.
     */
    public func isTaken(name: String, completionHandler: @escaping ((Bool) -> Void)) {
        let query = cloudkit.generateQuery(of: .channels, with: NSPredicate(format: "name ==[c] %@", name),
                                           sortedBy: NSSortDescriptor(key: "creationDate", ascending: false))
        cloudkit.query(using: query, on: .publicDB) { (response) in
            if response.error != nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    // MARK: Private functions

    /**
     Fetches a complete CKRecord with its references. Async function.
     - Parameters:
        - channelID: A channel's ID as a string.
        - completionHandler: Returns a complete ChannelModel as the result of the async function.
     */
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
