//
//  TextFieldExtension.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " 
    }
    
}
