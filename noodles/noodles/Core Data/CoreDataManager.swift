//
//  CoreDataManager.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 16/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import CoreData

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
    private func fetch() -> ([Channel], [Post], [User]) {
        var channelMock = [Channel]()
        var postMock = [Post]()
        var userMock = [User]()
        do {
            channelMock = try context.fetch(Channel.fetchRequest())
            postMock = try context.fetch(Post.fetchRequest())
            userMock = try context.fetch(User.fetchRequest())
        } catch let error as NSError {
            print("Failed to retrieve Channels from Core Data. \(error), \(error.userInfo)")
        }
        return (channelMock, postMock, userMock)
    }
    public func getData() -> ([Channel], [Post], [User]){
        let channels = fetch().0
        let posts = fetch().1
        let users = fetch().2
        return (channels, posts, users)
    }
    public func addChannel(channel: Channel) -> CoreDataStatus {
        let newChannel = Channel(context: context)
        newChannel.id = channel.id
        newChannel.name = channel.name
        newChannel.createdAt = channel.createdAt
        newChannel.createdBy = channel.createdBy
        newChannel.canBeEditedBy = channel.canBeEditedBy
        newChannel.canBeViewedBy = channel.canBeViewedBy
        do {
            try context.save()
        } catch {
            return CoreDataStatus(successful: false,
                description: "Failed to add Channel to Core Data.")
        }
        let response = CoreDataStatus(successful: true)
        response.channelIdentifier = channel
        return response
    }
    public func editChannel(target: Channel, newName: String?, newViewers: NSSet?, newEditors: NSSet?) -> CoreDataStatus {
        target.name = newName
        target.canBeEditedBy = newViewers
        target.canBeEditedBy = newEditors
        do {
            try context.save()
        } catch {
            return CoreDataStatus(successful: false, description: "Failed to edit Channel in Core Data")
        }
        return CoreDataStatus(successful: false, description: "No modifications")
    }
    public func addPost(target: Channel, post: Post) -> CoreDataStatus {
        let newPost = Post(context: context)
        newPost.id = post.id
        newPost.title = post.title
        newPost.body = post.body
        newPost.author = post.author
        newPost.tags = post.tags
        newPost.addToChannels(target)
        do {
            try context.save()
        } catch {
            return CoreDataStatus(successful: false, description: "Failed to add Post to Core Data")
        }
        let response = CoreDataStatus(successful: true)
        return response
    }
    public func editPost(target: Post, newTitle: String?, newBody: String?, newTags: [String]) -> CoreDataStatus {
        target.title = newTitle
        target.body = newBody
        target.tags = newTags
        do {
            try context.save()
        } catch {
            return CoreDataStatus(successful: false, description: "Failed to edit Post in Core Data")
        }
        return CoreDataStatus(successful: false, description: "No modifications")
    }
    public func addUser(user: User) -> CoreDataStatus {
        let newUser = User(context: context)
        newUser.name = user.name
        newUser.id = user.id
        newUser.rank = user.rank
        do {
            try context.save()
        } catch {
            return CoreDataStatus(successful: false, description: "Failed to add User to Core Data")
        }
        let response = CoreDataStatus(successful: true)
        return response
    }
    public func editUser(target: User, newName: String?, newRank: Rank?) -> CoreDataStatus {
        target.name = newName
        target.rank = newRank
        do {
            try context.save()
        } catch {
            return CoreDataStatus(successful: false, description: "Failed to edit User in Core Data")
        }
        return CoreDataStatus(successful: false, description: "No modifications")
    }
    public func addRank(rank: Rank) -> CoreDataStatus {
        let newRank = Rank(context: context)
        newRank.id = rank.id
        newRank.canCreateChannel = rank.canCreateChannel
        newRank.canEditChannels = rank.canEditChannels
        newRank.canViewChannels = rank.canViewChannels
        do {
            try context.save()
        } catch {
            return CoreDataStatus(successful: false, description: "Failed to add Rank to Core Data")
        }
        let response = CoreDataStatus(successful: true)
        return response
    }
}
