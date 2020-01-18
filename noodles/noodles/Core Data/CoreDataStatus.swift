//
//  CoreDataStatus.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 16/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

public class CoreDataStatus{
    public private(set) var successful:Bool
    public private(set) var description:String
    public var channelIdentifier:Channel?

    init(successful:Bool, description:String) {
        self.successful = successful
        self.description = description
    }

    convenience init(successful:Bool){
        self.init(successful:successful, description:"")
    }

}
