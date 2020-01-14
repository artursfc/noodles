//
//  UIColor+Extensions.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 14/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var main: UIColor {
        return #colorLiteral(red: 0.9921568627, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
    }
    
    class var fakeWhite: UIColor {
        return #colorLiteral(red: 0.9960784314, green: 1, blue: 1, alpha: 1)
    }
    
    class var fakeBlack: UIColor {
        return #colorLiteral(red: 0.1058823529, green: 0.1058823529, blue: 0.1058823529, alpha: 1)
    }
    
    class var alphaGray: UIColor {
        return #colorLiteral(red: 0.5607843137, green: 0.5529411765, blue: 0.5921568627, alpha: 1)
    }
    
    class var betaGray: UIColor {
        return #colorLiteral(red: 0.7921568627, green: 0.7843137255, blue: 0.8156862745, alpha: 1)
    }
    
    class var gammaGray: UIColor {
        return #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
    }
}
