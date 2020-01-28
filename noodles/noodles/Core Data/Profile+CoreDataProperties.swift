//
//  Profile+CoreDataProperties.swift
//  noodles
//
//  Created by Artur Carneiro on 27/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var bookmarks: [String]?

}
