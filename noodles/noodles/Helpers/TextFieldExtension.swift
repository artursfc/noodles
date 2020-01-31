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
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
         
         let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                               y: 0.0,
                                               width: UIScreen.main.bounds.size.width,
                                               height: 44.0))//1
         let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
         let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
         toolBar.setItems([flexible, barButton], animated: false)//4
         self.inputAccessoryView = toolBar//5
     }
    
}
