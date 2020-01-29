//
//  CreatePostViewController.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var firstCellView: UIView!
    @IBOutlet weak var secondCellVIew: UIView!
    @IBOutlet weak var thirdCellView: UIView!
    
    @IBOutlet weak var firstCellCheckPlaceHolder: UIImageView!
    @IBOutlet weak var SecondCellCheckPlaceHolder: UIImageView!
    @IBOutlet weak var thirdCellCheckPlaceHolder: UIImageView!
    
    @IBOutlet weak var postNameTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var channelsSelectorTextField: UITextField!
    
    @IBOutlet weak var addPostButton: UIView!
    
    var postName: String?
    
    var delegate: AddPostDelegate?
    
    var viewModel = PostModel(id: "id", title: "title", body: "body", author: nil, tags: ["tag1", "tag2"], readBy: [], validated: true, createdAt: nil, editedAt: nil, channels: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCheck()
        feed()
        addGestureRecognizer()

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        
        modalView.backgroundColor = UIColor.fakeWhite
        
        addBottomBorders()
        
        tagsTextField.placeholder = "Adicionar Tags"
        
        channelsSelectorTextField.placeholder = "Adicionar Canais"
        
        addPostButton.backgroundColor = UIColor.main
        
        if postName != "" {
            postNameTextField.text = postName
        } else {
            postNameTextField.placeholder = "Adicionar Titutlo"
        }
        
    }
    
    func feed() {
        
        if let tags = tagsTextField.text?.prefix(3) {
            viewModel.tags = tags.components(separatedBy: ", ")
        }
        
    }
    
    func addBottomBorders() {
        let thickness: CGFloat = 1.0
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.firstCellView.frame.size.height - thickness, width:self.firstCellView.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.fakeBlack.cgColor
        firstCellView.layer.addSublayer(bottomBorder)
        secondCellVIew.layer.addSublayer(bottomBorder)
    }
    
    func setupCheck() {
        if postNameTextField.isEmpty == false, postNameTextField.hasText {
            firstCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        }
        if tagsTextField.isEmpty == false, tagsTextField.hasText {
            SecondCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        }
        if channelsSelectorTextField.isEmpty == false, channelsSelectorTextField.hasText {
            thirdCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        }
    }
    
    func addGestureRecognizer() {
        
        let addPostGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(addPost))
        addPostButton.addGestureRecognizer(addPostGestureRecognizer)
    }
    
    @objc func addPost() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
