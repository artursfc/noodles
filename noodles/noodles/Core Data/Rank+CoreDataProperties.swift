//
//  Rank+CoreDataProperties.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//
//

import Foundation
import CoreData

extension Rank {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rank> {
        return NSFetchRequest<Rank>(entityName: "Rank")
    }

    @NSManaged public var canCreateChannel: Bool
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var editedAt: Date?
    @NSManaged public var canEditChannels: NSSet?
    @NSManaged public var canViewChannels: NSSet?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for canEditChannels
extension Rank {

    @objc(addCanEditChannelsObject:)
    @NSManaged public func addToCanEditChannels(_ value: Channel)

    @objc(removeCanEditChannelsObject:)
    @NSManaged public func removeFromCanEditChannels(_ value: Channel)

    @objc(addCanEditChannels:)
    @NSManaged public func addToCanEditChannels(_ values: NSSet)

    @objc(removeCanEditChannels:)
    @NSManaged public func removeFromCanEditChannels(_ values: NSSet)

}

// MARK: Generated accessors for canViewChannels
extension Rank {

    @objc(addCanViewChannelsObject:)
    @NSManaged public func addToCanViewChannels(_ value: Channel)

    @objc(removeCanViewChannelsObject:)
    @NSManaged public func removeFromCanViewChannels(_ value: Channel)

    @objc(addCanViewChannels:)
    @NSManaged public func addToCanViewChannels(_ values: NSSet)

    @objc(removeCanViewChannels:)
    @NSManaged public func removeFromCanViewChannels(_ values: NSSet)

}

// MARK: Generated accessors for users
extension Rank {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: User)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: User)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
