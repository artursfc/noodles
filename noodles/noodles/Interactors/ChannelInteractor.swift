//
//  ChannelInteractor.swift
//  noodles
//
//  Created by Artur Carneiro on 20/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CloudKit

enum DataProvider {
    case cloudkit
}

enum InteractorParser {
    case posts
    case users
    case channels
    case ranks
}

protocol Parseable {
    
}

final class ChannelInteractor {
    private let cloudkit: CloudKitManager
    private let coredata: CoreDataManager

    init(cloudkit: CloudKitManager, coredata: CoreDataManager) {
        self.cloudkit = cloudkit
        self.coredata = coredata
    }

    public func fetch(withChannelID: String, from provider: DataProvider, completionHandler: @escaping ((ChannelModel?) -> Void)) {
        switch provider {
        case .cloudkit:
            let recordID = CKRecord.ID(recordName: withChannelID)
            cloudkit.fetch(recordID: recordID, on: .publicDB) { [weak self] (response) in
                if response.error == nil {
                    guard let record = response.records?.first else {
                        return
                    }
                    var channel = ChannelModel(id: withChannelID, posts: nil, createdBy: nil,
                                               canBeEditedBy: nil, canBeViewedBy: nil, createdAt: record["createdAt"] ?? nil,
                                               editedAt: record["modifiedAt"] ?? nil)
                    if let postsRef = record["posts"] as? [CKRecord.Reference] {
                        var postsID = [CKRecord.ID]()
                        for postRef in postsRef {
                            postsID.append(postRef.recordID)
                        }
                        self?.cloudkit.fetchReferences(of: postsID, on: .publicDB, completionHandler: { [weak self] (response) in
                            if let records = response.records {
                                let postsModels = self?.parse(records: records, into: .posts)
                                if let posts = postsModels as? [PostModel] {
                                    channel.posts = posts
                                    DispatchQueue.main.async {
                                        completionHandler(channel)
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    completionHandler(nil)
                                }
                            }
                        })
                    }
                }
            }
        }
    }

    private func parse(records: [CKRecord], into model: InteractorParser) -> [Parseable]? {
        switch model {
        case .users:
            var users = [UserModel]()
            for record in records {
                let id = record.recordID.recordName
                let user = UserModel(id: id, name: record["name"] ?? "", rank: nil,
                                     createdAt: record["createdAt"] ?? nil, editedAt: record["modifiedAt"] ?? nil)
                users.append(user)
            }
            return users
        case .channels:
            var channels = [ChannelModel]()
            for record in records {
                let id = record.recordID.recordName
                let channel = ChannelModel(id: id, posts: nil, createdBy: nil, canBeEditedBy: nil,
                                           canBeViewedBy: nil, createdAt: record["createdAt"] ?? nil, editedAt: record["modifiedAt"] ?? nil)
                channels.append(channel)
            }
            return channels
        case .ranks:
            var ranks = [RankModel]()
            for record in records {
                let id = record.recordID.recordName
                if record["canCreateChannel"] != 0 {
                    let rank = RankModel(id: id, title: record["title"] ?? "", canEdit: nil, canView: nil,
                                         canCreateChannel: true, createdAt: record["createdAt"], editedAt: record["modifiedAt"] ?? nil)
                    ranks.append(rank)
                } else {
                    let rank = RankModel(id: id, title: record["title"] ?? "", canEdit: nil, canView: nil,
                                         canCreateChannel: false, createdAt: record["createdAt"] ?? nil, editedAt: record["modifiedAt"] ?? nil)
                    ranks.append(rank)
                }
            }
            return ranks
        case .posts:
            var posts = [PostModel]()
            for record in records {
                let id = record.recordID.recordName
                let post = PostModel(id: id, title: record["title"] ?? "", body: record["body"] ?? "",
                                     author: nil, tags: record["tags"] ?? [], readBy: nil,
                                     validated: true, createdAt: record["createdAt"] ?? nil,
                                     editedAt: record["modifiedAt"] ?? nil, channels: nil)
                posts.append(post)
            }
            return posts
        }
    }

}
