//
//  User+CoreDataProperties.swift
//  noodles
//
//  Created by Eloisa Falcão on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var editedAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var posts: NSSet?
    @NSManaged public var rank: Rank?

}

// MARK: Generated accessors for posts
extension User {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Post)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Post)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
