//
//  RankInteractor.swift
//  noodles
//
//  Created by Artur Carneiro on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

final class RankInteractor {
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
     Fetches a rank from a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - rankID: A rank's ID as a string.
        - provider: Enum used to determine from which Data Provider to fetch data.
        - completionHandler: Returns a RankModel as the result of the async function.
     */
    public func fetch(with rankID: String, from provider: DataProvider, completionHandler: @escaping ((RankModel?) -> Void)) {
        switch provider {
        case .cloudkit:
            fetch(with: rankID) { (rank) in
                if let rank = rank {
                    completionHandler(rank)
                } else {
                    completionHandler(nil)
                }
            }
        case .coredata:
            completionHandler(nil)
        }
    }

    /**
     Fetches all ranks from a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - provider: Enum used to determine from which Data Provider to fetch data.
        - completionHandler: Returns an array of RankModel as the result of the async function.
     */
    public func fetchAll(from provider: DataProvider, completionHandler: @escaping (([RankModel]?) -> Void)) {
        switch provider {
        case .cloudkit:
            let query = cloudkit.generateQuery(of: .ranks, with: NSPredicate(value: true), sortedBy: NSSortDescriptor(key: "creationDate", ascending: false))
            cloudkit.query(using: query, on: .publicDB) { [weak self] (response) in
                if response.error != nil {
                    completionHandler(nil)
                } else {
                    if let records = response.records {
                        let rankModels = self?.parser.parse(records: records, into: .ranks)
                        if let ranks = rankModels as? [RankModel] {
                            completionHandler(ranks)
                        }
                    }
                }
            }
        case .coredata:
            completionHandler(nil)
        }
    }

    /**
     Saves a rank on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - rank: A RankModel that will be saved to CKRecord.
        - completionHandler: Returns a Bool as the result of the async function.
     */
    public func save(rank: RankModel, completionHandler: @escaping ((Bool) -> Void)) {
        let models = [rank]
        let records = parser.parse(models: models, of: .ranks)
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
     Updates a rank on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - rank: A RankModel that will be updated.
        - newRank: A RankModel that will be used to update the rank.
        - completionHandler: Returns a Bool as the result of the async function.
     */
    public func update(rank: RankModel, with newRank: RankModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: rank.id)
        let models = [newRank]
        let records = parser.parse(models: models, of: .ranks)
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
     Deletes a rank on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - rank: A RankModel that will be deleted.
        - completionHandler: Returns a Bool as the result of the async function.
     */
    public func delete(rank: RankModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: rank.id)
        cloudkit.delete(recordID: recordID, on: .publicDB) { (response) in
            if response.error == nil && response.records == nil {
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
        - rankID: A rank's ID as a string.
        - completionHandler: Returns a complete RankModel as the result of the async function.
     */
    private func fetch(with rankID: String, completionHandler: @escaping ((RankModel?) -> Void)) {
        let recordID = CKRecord.ID(recordName: rankID)
        cloudkit.fetch(recordID: recordID, on: .publicDB) { [weak self] (response) in
            if response.error == nil {
                guard let record = response.records?.first else {
                    return
                }
                guard let canCreate = record["canCreateChannel"] as? Int else {
                    return
                }
                let canCreateBool = canCreate != 0 ? true : false
                var rank = RankModel(id: rankID, title: record["title"] ?? "", canEdit: nil,
                                     canView: nil, canCreateChannel: canCreateBool,
                                     createdAt: record["createdAt"] ?? nil, editedAt: record["editedAt"] ?? nil, users: nil)
                let group = DispatchGroup()
                if let editRefs = record["canEdit"] as? [CKRecord.Reference] {
                    var channelsID = [CKRecord.ID]()
                    for editRef in editRefs {
                        channelsID.append(editRef.recordID)
                    }
                    group.enter()
                    self?.cloudkit.fetchReferences(of: channelsID, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let records = response.records {
                            let channelModels = self?.parser.parse(records: records, into: .channels)
                            if let channels = channelModels as? [ChannelModel] {
                                rank.canEdit = channels
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                }
                if let viewRefs = record["canView"] as? [CKRecord.Reference] {
                    var channelsID = [CKRecord.ID]()
                    for viewRef in viewRefs {
                        channelsID.append(viewRef.recordID)
                    }
                    group.enter()
                    self?.cloudkit.fetchReferences(of: channelsID, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let records = response.records {
                            let channelModels = self?.parser.parse(records: records, into: .channels)
                            if let channels = channelModels as? [ChannelModel] {
                                rank.canView = channels
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                }
                if let usersRef = record["users"] as? [CKRecord.Reference] {
                    var usersID = [CKRecord.ID]()
                    for userRef in usersRef {
                        usersID.append(userRef.recordID)
                    }
                    group.enter()
                    self?.cloudkit.fetchReferences(of: usersID, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let records = response.records {
                            let userModels = self?.parser.parse(records: records, into: .users)
                            if let users = userModels as? [UserModel] {
                                rank.users = users
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                }
                group.notify(queue: .main) {
                    completionHandler(rank)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
}
