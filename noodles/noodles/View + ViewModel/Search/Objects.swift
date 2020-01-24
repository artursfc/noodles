//
//  Objects.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

struct Objects: Decodable {
  let name: String
  let category: Category
  
  enum Category: Decodable {
    case user
    case channel
    case post
    case undefined
  }
}

extension Objects.Category: CaseIterable { }

extension Objects.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: Self.RawValue) {
        switch rawValue {
        case "User":
            self = .user
        case "Channel":
            self = .channel
        case "Post":
            self = .post
        case "Undefined":
            self = .undefined
        default:
            return nil
        }
    }
    
    var rawValue: RawValue {
      switch self {
      case .user: return "User"
      case .channel: return "Channel"
      case .post: return "Post"
      case .undefined: return "Undefined"
      }
    }
    
}
