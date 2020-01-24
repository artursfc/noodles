//
//  Channel+CoreDataProperties.swift
//  noodles
//
//  Created by Eloisa Falcão on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//
//

import Foundation
import CoreData


extension Channel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Channel> {
        return NSFetchRequest<Channel>(entityName: "Channel")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var createdBy: String?
    @NSManaged public var editedAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var canBeEditedBy: NSSet?
    @NSManaged public var canBeViewedBy: NSSet?
    @NSManaged public var posts: NSSet?

}

// MARK: Generated accessors for canBeEditedBy
extension Channel {

    @objc(addCanBeEditedByObject:)
    @NSManaged public func addToCanBeEditedBy(_ value: Rank)

    @objc(removeCanBeEditedByObject:)
    @NSManaged public func removeFromCanBeEditedBy(_ value: Rank)

    @objc(addCanBeEditedBy:)
    @NSManaged public func addToCanBeEditedBy(_ values: NSSet)

    @objc(removeCanBeEditedBy:)
    @NSManaged public func removeFromCanBeEditedBy(_ values: NSSet)

}

// MARK: Generated accessors for canBeViewedBy
extension Channel {

    @objc(addCanBeViewedByObject:)
    @NSManaged public func addToCanBeViewedBy(_ value: Rank)

    @objc(removeCanBeViewedByObject:)
    @NSManaged public func removeFromCanBeViewedBy(_ value: Rank)

    @objc(addCanBeViewedBy:)
    @NSManaged public func addToCanBeViewedBy(_ values: NSSet)

    @objc(removeCanBeViewedBy:)
    @NSManaged public func removeFromCanBeViewedBy(_ values: NSSet)

}

// MARK: Generated accessors for posts
extension Channel {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Post)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Post)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
