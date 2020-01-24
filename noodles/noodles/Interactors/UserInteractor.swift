//
//  UserInteractor.swift
//  noodles
//
//  Created by Artur Carneiro on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

final class UserInteractor {
    private let cloudkit: CloudKitManager
    private let coredata: CoreDataManager
    private let parser: InteractorParser

    init(cloudkit: CloudKitManager, coredata: CoreDataManager) {
        self.cloudkit = cloudkit
        self.coredata = coredata
        self.parser = InteractorParser()
    }

    // MARK: Public functions
    public func fetch(with userID: String, from provider: DataProvider, completionHandler: @escaping ((UserModel?) -> Void)) {
        switch provider {
        case .cloudkit:
            fetch(with: userID) { (user) in
                if let user = user {
                    completionHandler(user)
                } else {
                    completionHandler(nil)
                }
            }
        case .coredata:
            completionHandler(nil)
        }
    }
    
    public func fetchAll(from provider: DataProvider, completionHandler: @escaping (([UserModel]?) -> Void)) {
        switch provider {
        case .cloudkit:
            let query = cloudkit.generateQuery(of: .users, with: NSPredicate(value: true),
                                               sortedBy: NSSortDescriptor(key: "creationDate", ascending: false))
            cloudkit.query(using: query, on: .publicDB) { [weak self] (response) in
                if response.error != nil {
                    completionHandler(nil)
                } else {
                    if let records = response.records {
                        let userModels = self?.parser.parse(records: records, into: .users)
                        if let users = userModels as? [UserModel] {
                            completionHandler(users)
                        }
                    }
                }
            }
        case .coredata:
            completionHandler(nil)
        }
    }

    public func save(user: UserModel, completionHandler: @escaping ((Bool) -> Void)) {
        let models = [user]
        let records = parser.parse(models: models, of: .users)
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

    public func update(user: UserModel, with newUser: UserModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: user.id)
        let models = [newUser]
        let records = parser.parse(models: models, of: .users)
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

    public func delete(user: UserModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: user.id)
        cloudkit.delete(recordID: recordID, on: .publicDB) { (response) in
            if response.error == nil && response.records == nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    // MARK: Private functions
    private func fetch(with userID: String, completionHandler: @escaping ((UserModel?) -> Void)) {
        let recordID = CKRecord.ID(recordName: userID)
        cloudkit.fetch(recordID: recordID, on: .publicDB) { [weak self] (response) in
            if response.error == nil {
                guard let record = response.records?.first else {
                    return
                }
                var user = UserModel(id: userID, name: record["name"] ?? "", rank: nil, createdAt: record["createdAt"] ?? nil,
                                     editedAt: record["modifiedAt"] ?? nil)
                if let rankRef = record["rank"] as? CKRecord.Reference {
                    self?.cloudkit.fetch(recordID: rankRef.recordID, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let record = response.records {
                            let rankModel = self?.parser.parse(records: record, into: .ranks)
                            if let rank = rankModel?.first as? RankModel {
                                user.rank = rank
                                completionHandler(user)
                            }
                        }
                    })
                }
            } else {
                completionHandler(nil)
            }
        }
    }
}
