//
//  CheckBoxCustomView.swift
//  noodles
//
//  Created by Edgar Sgroi on 22/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

@IBDesignable
class CheckBoxCustomView: UIButton {
    let checkedImage: UIImage? = UIImage(named: "checkedButton") as UIImage?
    let uncheckedImage: UIImage? = UIImage(named: "uncheckedButton") as UIImage?
    
    @IBInspectable
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
