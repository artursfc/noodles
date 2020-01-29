//
//  CoreDataManager.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 16/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CoreData

/**
 Used by CoreDataManager's functions completionHandler.
 Creates an unified response from Core Data.
 */
struct CoreDataResponse {
    var objects: [NSManagedObject]?
    var error: NSError?
}

/**
 Gives access to Core Data's objects/functionalities through async functions.
 */
final class CoreDataManager {    
    private let context: NSManagedObjectContext
    private let container: NSPersistentContainer

    public init() {
        container = NSPersistentContainer(name: "noodles")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Could not load CoreData. \(error), \(error.userInfo)")
            }
        }
        context = container.viewContext
    }

    /**
     Saves an object into Core Data. Asyn function.
     - Parameters:
        - object: Any NSManagedObject described in the *.xcdatamodeld file.
        - type: Enum used to determine which record type is being used in the function.
        - completionHandler: Returns a CoreDataResponse as the result of the async function.
     */
    public func save(object: NSManagedObject, of type: RecordType, completionHandler: @escaping ((CoreDataResponse) -> Void)) {
        container.performBackgroundTask { (pvtContext) in
            switch type {
            case .channels:
                if let channel = object as? Channel {
                    let saveChannel = Channel(context: pvtContext)
                    saveChannel.id = channel.id
                    saveChannel.name = channel.name
                    saveChannel.posts = channel.posts
                    saveChannel.createdBy = channel.createdBy
                    saveChannel.canBeEditedBy = channel.canBeEditedBy
                    saveChannel.canBeViewedBy = channel.canBeViewedBy
                    saveChannel.createdAt = channel.createdAt
                    saveChannel.editedAt = channel.editedAt
                    do {
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .ranks:
                if let rank = object as? Rank {
                    let saveRank = Rank(context: pvtContext)
                    saveRank.id = rank.id
                    saveRank.title = rank.title
                    saveRank.canEditChannels = rank.canEditChannels
                    saveRank.canViewChannels = rank.canViewChannels
                    saveRank.canCreateChannel = rank.canCreateChannel
                    saveRank.createdAt = rank.createdAt
                    saveRank.editedAt = rank.editedAt
                    saveRank.users = rank.users
                    do {
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .users:
                if let user = object as? User {
                    let saveUser = User(context: pvtContext)
                    saveUser.id = user.id
                    saveUser.name = user.name
                    saveUser.rank = user.rank
                    saveUser.createdAt = user.createdAt
                    saveUser.editedAt = user.editedAt
                    do {
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .posts:
                if let post = object as? Post {
                    let savePost = Post(context: pvtContext)
                    savePost.id = post.id
                    savePost.title = post.title
                    savePost.body = post.body
                    savePost.author = post.author
                    savePost.tags = post.tags
                    savePost.readBy = post.readBy
                    savePost.validated = post.validated
                    savePost.createdAt = post.createdAt
                    savePost.editedAt = post.editedAt
                    savePost.channels = post.channels
                    do {
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            }
        }
    }

    /**
     Fetches all objects of any record type. Async function.
     - Parameters:
        - objects: Enum used to determine which record type is being used in the function.
        - completionHandler: Returns a CoreDataResponse as the result of the async function.
     */
    public func fetchAll(objects: RecordType, completionHandler: @escaping ((CoreDataResponse) -> Void)) {
        let pvtContext = container.newBackgroundContext()
        switch objects {
        case .users:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            let asyncReq = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
                if let result = result.finalResult as? [User] {
                    completionHandler(CoreDataResponse(objects: result, error: nil))
                }
            }
            do {
                try pvtContext.execute(asyncReq)
            } catch let error as NSError {
                completionHandler(CoreDataResponse(objects: nil, error: error))
            }
        case .ranks:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Rank")
            let asyncReq = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
                if let result = result.finalResult as? [Rank] {
                    completionHandler(CoreDataResponse(objects: result, error: nil))
                }
            }
            do {
                try pvtContext.execute(asyncReq)
            } catch let error as NSError {
                completionHandler(CoreDataResponse(objects: nil, error: error))
            }
        case .channels:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Channel")
            let asyncReq = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
                if let result = result.finalResult as? [Channel] {
                    completionHandler(CoreDataResponse(objects: result, error: nil))
                }
            }
            do {
                try pvtContext.execute(asyncReq)
            } catch let error as NSError {
                completionHandler(CoreDataResponse(objects: nil, error: error))
            }
        case .posts:
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            let asyncReq = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
                if let result = result.finalResult as? [Post] {
                    completionHandler(CoreDataResponse(objects: result, error: nil))
                }
            }
            do {
                try pvtContext.execute(asyncReq)
            } catch let error as NSError {
                completionHandler(CoreDataResponse(objects: nil, error: error))
            }
        }
    }

    /**
     Updates object of any record type. Asyn function.
     - Parameters:
        - object: Any NSManagedObject described in the *.xcdatamodeld file.
        - newObject: New object of any NSManagedObject described in the *.xcdatamodeld file.
        - type: Enum used to determine which record type is being used in the function.
        - completionHandler: Returns a CoreDataResponse as the result of the async function.
     */
    public func update(object: NSManagedObject, with newObject: NSManagedObject, of type: RecordType,
                       completionHandler: @escaping ((CoreDataResponse) -> Void)) {
        container.performBackgroundTask { (pvtContext) in
            switch type {
            case .channels:
                if let newChannel = newObject as? Channel, let oldChannel = object as? Channel {
                    oldChannel.name = newChannel.name
                    oldChannel.posts = newChannel.posts
                    oldChannel.createdBy = newChannel.createdBy
                    oldChannel.canBeEditedBy = newChannel.canBeEditedBy
                    oldChannel.canBeViewedBy = newChannel.canBeViewedBy
                    oldChannel.editedAt = newChannel.editedAt
                    do {
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .ranks:
                if let newRank = newObject as? Rank, let oldRank = object as? Rank {
                    oldRank.title = newRank.title
                    oldRank.canEditChannels = newRank.canEditChannels
                    oldRank.canViewChannels = newRank.canViewChannels
                    oldRank.canCreateChannel = newRank.canCreateChannel
                    oldRank.editedAt = newRank.editedAt
                    oldRank.users = newRank.users
                    do {
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .users:
                if let newUser = newObject as? User, let oldUser = object as? User {
                    oldUser.name = newUser.name
                    oldUser.rank = newUser.rank
                    oldUser.editedAt = newUser.editedAt
                    do {
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .posts:
                if let newPost = newObject as? Post, let oldPost = object as? Post {
                    oldPost.title = newPost.title
                    oldPost.body = newPost.body
                    oldPost.author = newPost.author
                    oldPost.tags = newPost.tags
                    oldPost.readBy = newPost.readBy
                    oldPost.validated = newPost.validated
                    oldPost.editedAt = newPost.editedAt
                    oldPost.channels = newPost.channels
                    do {
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            }
        }
    }
    /**
     Deletes an object from Core Data. Async function.
     - Parameters:
        - object: Any NSManagedObject described in the *.xcdatamodeld file.
        - type: Enum used to determine which record type is being used in the function.
        - completionHandler: Returns a CoreDataResponse as the result of the async function.
     */
    public func delete(object: NSManagedObject, of type: RecordType, completionHandler: @escaping ((CoreDataResponse) -> Void)) {
        container.performBackgroundTask { (pvtContext) in
            switch type {
            case .channels:
                if let channel = object as? Channel {
                    do {
                        pvtContext.delete(channel)
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .posts:
                if let post = object as? Post {
                    do {
                        pvtContext.delete(post)
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .ranks:
                if let rank = object as? Rank {
                    do {
                        pvtContext.delete(rank)
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            case .users:
                if let user = object as? User {
                    do {
                        pvtContext.delete(user)
                        try pvtContext.save()
                    } catch let error as NSError {
                        completionHandler(CoreDataResponse(objects: nil, error: error))
                    }
                    completionHandler(CoreDataResponse(objects: nil, error: nil))
                }
            }
        }
    }
}
