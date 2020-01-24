//
//  InteractorParser.swift
//  noodles
//
//  Created by Artur Carneiro on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

final class InteractorParser {
    init() {}

    // MARK: Public functions
    public func parse(records: [CKRecord], into model: StructType) -> [Parseable]? {
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
                let channel = ChannelModel(id: id, name: record["name"] ?? "", posts: nil, createdBy: nil, canBeEditedBy: nil,
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
                                         canCreateChannel: true, createdAt: record["createdAt"], editedAt: record["modifiedAt"] ?? nil, users: nil)
                    ranks.append(rank)
                } else {
                    let rank = RankModel(id: id, title: record["title"] ?? "", canEdit: nil, canView: nil,
                                         canCreateChannel: false, createdAt: record["createdAt"] ?? nil,
                                         editedAt: record["modifiedAt"] ?? nil, users: nil)
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

    public func parse(models: [Parseable], of type: StructType) -> [CKRecord] {
        switch type {
        case .channels:
            guard let channels = models as? [ChannelModel] else {
                return [CKRecord]()
            }
            return parse(channels: channels)
        case .ranks:
            guard let ranks = models as? [RankModel] else {
                return [CKRecord]()
            }
            return parse(ranks: ranks)
        case .posts:
            guard let posts = models as? [PostModel] else {
                return [CKRecord]()
            }
            return parse(posts: posts)
        case .users:
            guard let users = models as? [UserModel] else {
                return [CKRecord]()
            }
            return parse(users: users)
        }
    }

    public func parse(objects: [NSManagedObject], into model: StructType) -> [Parseable]? {
        switch model {
        case .channels:
            if let channelObjects = objects as? [Channel] {
                var channels = [ChannelModel]()
                for object in channelObjects {
                    let model = ChannelModel(id: object.id ?? "", name: object.name ?? "", posts: nil, createdBy: nil,
                                             canBeEditedBy: nil, canBeViewedBy: nil,
                                             createdAt: object.createdAt ?? nil, editedAt: object.editedAt ?? nil)
                    channels.append(model)
                }
                return channels
            }
            return nil
        case .posts:
            if let postObjects = objects as? [Post] {
                var posts = [PostModel]()
                for object in postObjects {
                    let model = PostModel(id: object.id ?? "", title: object.title ?? "", body: object.body ?? "",
                                          author: nil, tags: object.tags ?? [], readBy: nil, validated: object.validated,
                                          createdAt: object.createdAt ?? nil, editedAt: object.editedAt ?? nil, channels: nil)
                    posts.append(model)
                }
                return posts
            }
            return nil
        case .ranks:
            if let rankObjects = objects as? [Rank] {
                var ranks = [RankModel]()
                for object in rankObjects {
                    let model = RankModel(id: object.id ?? "", title: object.title ?? "", canEdit: nil,
                                          canView: nil, canCreateChannel: object.canCreateChannel, createdAt: object.createdAt ?? nil,
                                          editedAt: object.editedAt ?? nil, users: nil)
                    ranks.append(model)
                }
                return ranks
            }
            return nil
        case .users:
            if let userObjects = objects as? [User] {
                var users = [UserModel]()
                for object in userObjects {
                    let model = UserModel(id: object.id ?? "", name: object.name ?? "", rank: nil,
                                          createdAt: object.createdAt ?? nil, editedAt: object.editedAt ?? nil)
                    users.append(model)
                }
                return users
            }
        }
        return nil
    }

    // MARK: Private functions
    private func parse(channels: [ChannelModel]) -> [CKRecord] {
        var records = [CKRecord]()
        for channel in channels {
            let record = CKRecord(recordType: "Channels")
            if let beViewedRefs = channel.canBeViewedBy {
                var references = [CKRecord.Reference]()
                for beViewedRef in beViewedRefs {
                    let recordID = CKRecord.ID(recordName: beViewedRef.id)
                    let ref = CKRecord.Reference(recordID: recordID, action: .none)
                    references.append(ref)
                }
                record["canBeViewedBy"] = references as CKRecordValue
            }
            if let beEditedRefs = channel.canBeEditedBy {
                var references = [CKRecord.Reference]()
                for beEditedRef in beEditedRefs {
                    let recordID = CKRecord.ID(recordName: beEditedRef.id)
                    let ref = CKRecord.Reference(recordID: recordID, action: .none)
                    references.append(ref)
                }
                record["canBeEditedBy"] = references as CKRecordValue
            }
            if let posts = channel.posts {
                var references = [CKRecord.Reference]()
                for post in posts {
                    let recordID = CKRecord.ID(recordName: post.id)
                    let ref = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                    references.append(ref)
                }
                record["posts"] = references as CKRecordValue
            }
            record["name"] = channel.name as CKRecordValue
            records.append(record)
        }
        return records
    }

    private func parse(posts: [PostModel]) -> [CKRecord] {
        var records = [CKRecord]()
        for post in posts {
            let record = CKRecord(recordType: "Posts")
            if let authorRef = post.author {
                let recordID = CKRecord.ID(recordName: authorRef.id)
                let ref = CKRecord.Reference(recordID: recordID, action: .none)
                record["author"] = ref as CKRecordValue
            }
            if let channelRefs = post.channels {
                var references = [CKRecord.Reference]()
                for channelRef in channelRefs {
                    let recordID = CKRecord.ID(recordName: channelRef.id)
                    let ref = CKRecord.Reference(recordID: recordID, action: .none)
                    references.append(ref)
                }
                record["channels"] = references as CKRecordValue
            }
            if let readByRefs = post.readBy {
                var references = [CKRecord.Reference]()
                for readByRef in readByRefs {
                    let recordID = CKRecord.ID(recordName: readByRef.id)
                    let ref = CKRecord.Reference(recordID: recordID, action: .none)
                    references.append(ref)
                }
                record["readBy"] = references as CKRecordValue
            }
            let validated = post.validated == true ? 1 : 0
            record["validated"] = validated as CKRecordValue
            record["body"] = post.body as CKRecordValue
            record["tags"] = post.tags as CKRecordValue
            record["title"] = post.title as CKRecordValue
            records.append(record)
        }
        return records
    }

    private func parse(ranks: [RankModel]) -> [CKRecord] {
        var records = [CKRecord]()
        for rank in ranks {
            let record = CKRecord(recordType: "Ranks")
            if let editRefs = rank.canEdit {
                var references = [CKRecord.Reference]()
                for editRef in editRefs {
                    let recordID = CKRecord.ID(recordName: editRef.id)
                    let ref = CKRecord.Reference(recordID: recordID, action: .none)
                    references.append(ref)
                }
                record["canEdit"] = references as CKRecordValue
            }
            if let viewRefs = rank.canView {
                var references = [CKRecord.Reference]()
                for viewRef in viewRefs {
                    let recordID = CKRecord.ID(recordName: viewRef.id)
                    let ref = CKRecord.Reference(recordID: recordID, action: .none)
                    references.append(ref)
                }
                record["canView"] = references as CKRecordValue
            }
            if let usersRefs = rank.users {
                var references = [CKRecord.Reference]()
                for userRef in usersRefs {
                    let recordID = CKRecord.ID(recordName: userRef.id)
                    let ref = CKRecord.Reference(recordID: recordID, action: .none)
                    references.append(ref)
                }
                record["users"] = references as CKRecordValue
            }
            let canCreate = rank.canCreateChannel == true ? 1 : 0
            record["canCreateChannel"] = canCreate as CKRecordValue
            record["title"] = rank.title as CKRecordValue
            records.append(record)
        }
        return records
    }

    private func parse(users: [UserModel]) -> [CKRecord] {
        var records = [CKRecord]()
        for user in users {
            let record = CKRecord(recordType: "Users")
            if let rankRef = user.rank {
                let recordID = CKRecord.ID(recordName: rankRef.id)
                let ref = CKRecord.Reference(recordID: recordID, action: .none)
                record["rank"] = ref as CKRecordValue
            }
            record["name"] = user.name
            records.append(record)
        }
        return records
    }
}
