//
//  Post+CoreDataProperties.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var editedAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var readBy: [String]?
    @NSManaged public var tags: [String]?
    @NSManaged public var title: String?
    @NSManaged public var validated: Bool
    @NSManaged public var author: User?
    @NSManaged public var channels: NSSet?

}

// MARK: Generated accessors for channels
extension Post {

    @objc(addChannelsObject:)
    @NSManaged public func addToChannels(_ value: Channel)

    @objc(removeChannelsObject:)
    @NSManaged public func removeFromChannels(_ value: Channel)

    @objc(addChannels:)
    @NSManaged public func addToChannels(_ values: NSSet)

    @objc(removeChannels:)
    @NSManaged public func removeFromChannels(_ values: NSSet)

}
