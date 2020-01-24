//
//  PostInteractor.swift
//  noodles
//
//  Created by Artur Carneiro on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

final class PostInteractor {
    private let cloudkit: CloudKitManager
    private let coredata: CoreDataManager
    private let parser: InteractorParser

    init(cloudkit: CloudKitManager, coredata: CoreDataManager) {
        self.cloudkit = cloudkit
        self.coredata = coredata
        self.parser = InteractorParser()
    }

    // MARK: Public fucntions
    public func fetch(with postID: String, from provider: DataProvider, completionHandler: @escaping ((PostModel?) -> Void)) {
        switch provider {
        case .cloudkit:
            fetch(with: postID) { (post) in
                if let post = post {
                    DispatchQueue.main.async {
                        completionHandler(post)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                }
            }
        case .coredata:
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    public func fetchAll(from provider: DataProvider, completionHandler: @escaping (([PostModel]?) -> Void)) {
        switch provider {
        case .cloudkit:
            let query = cloudkit.generateQuery(of: .posts, with: NSPredicate(value: true), sortedBy: NSSortDescriptor(key: "creationDate", ascending: false))
            cloudkit.query(using: query, on: .publicDB) { [weak self] (response) in
                if response.error != nil {
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                } else {
                    if let records = response.records {
                        let postModels = self?.parser.parse(records: records, into: .posts)
                        if let posts = postModels as? [PostModel] {
                            DispatchQueue.main.async {
                                completionHandler(posts)
                            }
                        }
                    }
                }
            }
        case .coredata:
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }

    public func save(post: PostModel, completionHandler: @escaping ((Bool) -> Void)) {
        let models = [post]
        let records = parser.parse(models: models, of: .posts)
        if records.isEmpty {
            DispatchQueue.main.async {
                completionHandler(false)
            }
        }
        if let record = records.first {
            cloudkit.save(record: record, on: .publicDB) { (response) in
                if response.error == nil && response.records == nil {
                    DispatchQueue.main.async {
                        completionHandler(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false)
                    }
                }
            }
        }
    }

    public func update(post: PostModel, with newPost: PostModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: post.id)
        let models = [newPost]
        let records = parser.parse(models: models, of: .posts)
        if records.isEmpty {
            DispatchQueue.main.async {
                completionHandler(false)
            }
        }
        if let record = records.first {
            cloudkit.update(recordID: recordID, with: record, on: .publicDB) { (response) in
                if response.error == nil && response.records == nil {
                    DispatchQueue.main.async {
                        completionHandler(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false)
                    }
                }
            }
        }
    }

    public func delete(post: PostModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: post.id)
        cloudkit.delete(recordID: recordID, on: .publicDB) { (response) in
            if response.error == nil && response.records == nil {
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(false)
                }
            }
        }
    }

    // MARK: Private functions
    private func fetch(with postID: String, completionHandler: @escaping ((PostModel?) -> Void)) {
        let recordID = CKRecord.ID(recordName: postID)
        cloudkit.fetch(recordID: recordID, on: .publicDB) { [weak self] (response) in
            if response.error == nil {
                guard let record = response.records?.first else {
                    return
                }
                guard let validated = record["validated"] as? Int else {
                    return
                }
                let validatedBool = validated != 0 ? true : false
                var post = PostModel(id: postID, title: record["title"] ?? "", body: record["body"] ?? "",
                                     author: nil, tags: record["tags"] ?? [],
                                     readBy: nil, validated: validatedBool, createdAt: record["createdAt"] ?? nil,
                                     editedAt: record["editedAt"] ?? nil, channels: nil)
                let group = DispatchGroup()
                if let usersRef = record["readBy"] as? [CKRecord.Reference] {
                    var usersID = [CKRecord.ID]()
                    for userRef in usersRef {
                        usersID.append(userRef.recordID)
                    }
                    group.enter()
                    self?.cloudkit.fetchReferences(of: usersID, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let records = response.records {
                            let userModels = self?.parser.parse(records: records, into: .users)
                            if let users = userModels as? [UserModel] {
                                post.readBy = users
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                }
                if let channelRefs = record["channels"] as? [CKRecord.Reference] {
                    var channelsID = [CKRecord.ID]()
                    for channelRef in channelRefs {
                        channelsID.append(channelRef.recordID)
                    }
                    group.enter()
                    self?.cloudkit.fetchReferences(of: channelsID, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let records = response.records {
                            let channelsModels = self?.parser.parse(records: records, into: .channels)
                            if let channels = channelsModels as? [ChannelModel] {
                                post.channels = channels
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                }
                if let authorRef = record["author"] as? CKRecord.Reference {
                    group.enter()
                    self?.cloudkit.fetch(recordID: authorRef.recordID, on: .publicDB, completionHandler: { [weak self] (response) in
                        if let record = response.records {
                            let usersModel = self?.parser.parse(records: record, into: .users)
                            if let user = usersModel?.first as? UserModel {
                                post.author = user
                                group.leave()
                            } else {
                                group.leave()
                            }
                        }
                    })
                }
                group.notify(queue: .main) {
                    completionHandler(post)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
}
