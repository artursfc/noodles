//
//  UserInteractor.swift
//  noodles
//
//  Created by Artur Carneiro on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

/**
 Interactor used by User-related ViewModels to connect with Core Data
 and CloudKit through a common struct(UserModel).
 */
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
    /**
     Fetches a user from a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - userID: A user's ID as a string.
        - provider: Enum used to determine from which Data Provider to fetch data.
        - completionHandler: Returns a UserModel as the result of the async function.
     */
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

    /**
     Fetches all users from a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - provider: Enum used to determine from which Data Provider to fetch data.
        - completionHandler: Returns an array UserModel as the result of the async function.
     */
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

    /**
     Saves a user on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - user: A UserModel that will be saved to CKRecord.
        - completionHandler: Returns a Bool as the result of the async function.
     */
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

    /**
     Updates a user on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - user: A UserModel that will be updated.
        - newUser: A UserModel that will be used to update the user.
        - completionHandler: Returns a Bool as the result of the async function.
     */
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

    /**
     Deletes a user on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - user: A UserModel that will be deleted.
        - completionHandler: Returns a Bool as the result of the async function.
     */
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

    /**
     Fetches a complete CKRecord with its references. Async function.
     - Parameters:
        - userID: A user's as a string.
        - completionHandler: Returns a complete UserModel as the result of the async function.
     */
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
