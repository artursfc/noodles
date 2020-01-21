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
    case post
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

    public func fetch(withChannelID: String, from provider: DataProvider, completionHandler: @escaping ((ChannelModel) -> Void)) {
        switch provider {
        case .cloudkit:
            let recordID = CKRecord.ID(recordName: withChannelID)
            cloudkit.fetch(recordID: recordID, on: .publicDB) { [weak self] (response) in
                if response.error == nil {
                    guard let record = response.records?.first else {
                        return
                    }
                    var channel = ChannelModel(id: withChannelID, posts: nil, createdBy: nil,
                                               canBeEditedBy: nil, canBeViewedBy: nil, createdAt: record["createdAt"] ?? Date(),
                                               editedAt: record["modifiedAt"] ?? Date())
                    if let postsRef = record["posts"] as? [CKRecord.Reference] {
                        var postsID = [CKRecord.ID]()
                        for postRef in postsRef {
                            postsID.append(postRef.recordID)
                        }
                        self?.cloudkit.fetchReferences(of: postsID, on: .publicDB, completionHandler: { [weak self] (response) in
                            if let records = response.records {
                                let postsModels = self?.parse(records: records, into: .post, with: [channel])
                                if let posts = postsModels as? [PostModel] {
                                    channel.posts = posts
                                    DispatchQueue.main.async {
                                        completionHandler(channel)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
    }

    private func parse(records: [CKRecord], into model: InteractorParser, with relationship: [Parseable]? ) -> [Parseable]? {
        switch model {
        case .post:
            var posts = [PostModel]()
            if let parents = relationship as? [ChannelModel] {
                for record in records {
                    let id = record.recordID.recordName
                    let post = PostModel(id: id, title: record["title"] ?? "", body: record["body"] ?? "",
                                         author: nil, tags: record["tags"] ?? [], readBy: nil,
                                         validated: true, createdAt: record["createdAt"] ?? Date(),
                                         editedAt: record["editedAt"] ?? Date(), channels: parents)
                    posts.append(post)
                }
            }
            return posts
        }
    }

}
