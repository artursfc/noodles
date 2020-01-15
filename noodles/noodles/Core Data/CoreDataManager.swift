//
//  CoreDataManager.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//


import Foundation
import CoreData

final class CoreDataManager {    
    private let context: NSManagedObjectContext
    private let container: NSPersistentContainer
    private var delegates: [DataModifiedDelegate] = []
    private init() {
        container = NSPersistentContainer(name: "noodles")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Could not load CoreData. \(error), \(error.userInfo)")
            }
        }
        context = container.viewContext
    }
    func notify() {
        for delegate in delegates {
            delegate.dataModified()
        }
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
        do {
            try context.save()
            notify()
        } catch {
            return CoreDataStatus(successful: false,
                description: "Failed to add Channel to Core Data.")
        }
        let response = CoreDataStatus(successful: true)
        response.channelIdentifier = channel
        return response
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
            notify()
        } catch {
            return CoreDataStatus(successful: false, description: "Failed to add Post to Core Data")
        }
        let response = CoreDataStatus(successful: true)
        return response
    }
    public func addUser(user: User) -> CoreDataStatus {
        let newUser = User(context: context)
        newUser.id = user.id
        newUser.name = user.name
        newUser.rank = user.rank
        do {
            try context.save()
            notify()
        } catch {
            return CoreDataStatus(successful: false, description: "Failed to add User to Core Data")
        }
        let response = CoreDataStatus(successful: true)
        return response
    }
}
