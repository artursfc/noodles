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

/**
 Interactor used by Post-related ViewModels to connect with Core Data and CloudKit through a common struct(PostModel).
 */
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

    /**
     Fetches a post from a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - postID: A post's ID as a string.
        - provider: Enum used to determine from which Data Provider to fetch data.
        - completionHandler: Returns a PostModel as the result of the async function.
     */
    public func fetch(with postID: String, from provider: DataProvider, completionHandler: @escaping ((PostModel?) -> Void)) {
        switch provider {
        case .cloudkit:
            fetch(with: postID) { (post) in
                if let post = post {
                    completionHandler(post)
                } else {
                    completionHandler(nil)
                }
            }
        case .coredata:
            completionHandler(nil)
        }
    }

    public func fetch(with postIDs: [String], from provider: DataProvider, completionHandler: @escaping (([PostModel]?) -> Void)) {
        switch provider {
        case .cloudkit:
            var postRefs: [CKRecord.ID]?
            for postID in postIDs {
                let ref = CKRecord.ID(recordName: postID)
                postRefs?.append(ref)
            }
            if let postRefs = postRefs {
                cloudkit.fetchReferences(of: postRefs, on: .publicDB) { [weak self] (response) in
                    if response.error != nil {
                        completionHandler(nil)
                    } else {
                        if let records = response.records {
                            let postModels = self?.parser.parse(records: records, into: .posts)
                            if let posts = postModels as? [PostModel] {
                                completionHandler(posts)
                            }
                        }
                    }
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
    public func fetchAll(from provider: DataProvider, completionHandler: @escaping (([PostModel]?) -> Void)) {
        switch provider {
        case .cloudkit:
            let query = cloudkit.generateQuery(of: .posts, with: NSPredicate(value: true),
                                               sortedBy: NSSortDescriptor(key: "creationDate", ascending: false))
            cloudkit.query(using: query, on: .publicDB) { [weak self] (response) in
                if response.error != nil {
                    completionHandler(nil)
                } else {
                    if let records = response.records {
                        let postModels = self?.parser.parse(records: records, into: .posts)
                        if let posts = postModels as? [PostModel] {
                            completionHandler(posts)
                        }
                    }
                }
            }
        case .coredata:
            completionHandler(nil)
        }
    }

    /**
     Saves a rank on Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - post: A PostModel that will be saved as CKRecord.
        - completionHandler: Returns a Bool as the result of the async function.
     */
    public func save(post: PostModel, completionHandler: @escaping ((Bool) -> Void)) {
        let models = [post]
        let records = parser.parse(models: models, of: .posts)
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
     Updates a post on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - post: A PostModel that will be updated.
        - newPost: A Postmodel that will be used to update the post.
        - completionHandler: Returns a Bool as the result of the asynce function.
     */
    public func update(post: PostModel, with newPost: PostModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: post.id)
        let models = [newPost]
        let records = parser.parse(models: models, of: .posts)
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
     Deletes a post on a Data Provider, either CloudKit or Core Data. Async function.
     - Parameters:
        - post: A PostModel that will be deleted.
        - completionHandler: Returns a Bool as the result of the async function.
     */
    public func delete(post: PostModel, completionHandler: @escaping ((Bool) -> Void)) {
        let recordID = CKRecord.ID(recordName: post.id)
        cloudkit.delete(recordID: recordID, on: .publicDB) { (response) in
            if response.error == nil && response.records == nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    public func update(bookmarks: [String], completionHandler: @escaping ((Bool) -> Void)) {
        let defaults = UserDefaults.standard
        var oldProfile: Profile?
        coredata.fetchAll(objects: .profile) { (response) in
            if response.error != nil {
                completionHandler(false)
            } else {
                if let profile = response.objects?.first as? Profile {
                    oldProfile = profile
                }
            }
        }
        var profile = ProfileModel(id: defaults.object(forKey: "userID") as? String ?? "", name: oldProfile?.name ?? "", bookmarks: [String]())
        for bookmark in bookmarks {
            profile.bookmarks.append(bookmark)
        }
        if let oldProfile = oldProfile {
            coredata.update(object: oldProfile, with: profile, of: .profile) { (response) in
                if response.error == nil && response.objects == nil {
                    completionHandler(true)
                }
            }
        }
        completionHandler(false)
    }

    public func bookmarks(completionHandler: @escaping (([String]?) -> Void)) {
        coredata.fetchAll(objects: .profile) { (response) in
            if response.error != nil {
                completionHandler(nil)
            } else {
                if let profile = response.objects?.first as? Profile {
                    completionHandler(profile.bookmarks)
                }
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
                completionHandler(nil)
            }
        }
    }
}
