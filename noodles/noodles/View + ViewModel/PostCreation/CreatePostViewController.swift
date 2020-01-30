//
//  CreatePostViewController.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UITextFieldDelegate { 

    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var firstCellView: UIView!
    @IBOutlet weak var secondCellVIew: UIView!
    @IBOutlet weak var thirdCellView: UIView!
    
    @IBOutlet weak var firstCellCheckPlaceHolder: UIImageView!
    @IBOutlet weak var secondCellCheckPlaceHolder: UIImageView!
    @IBOutlet weak var thirdCellCheckPlaceHolder: UIImageView!
    
    @IBOutlet weak var postNameTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var channelsSelectorTextField: UITextField!
    
    @IBOutlet weak var addPostButton: UIView!
    
    var postName: String?
    var postBody: String?
    
//    var delegate: AddPostDelegate?
    
    var viewModel: AddPostViewModel?
    
    init(viewModel: AddPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CreatePostViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCheck()
        addGestureRecognizer()
        createPost()
        setupDelegates()
        addGestureRecognizer()
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if postNameTextField.isEmpty == false, postNameTextField.hasText {
            firstCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        } else {
            firstCellCheckPlaceHolder.image = UIImage(named: "waitingInputPlaceHolder")
        }
        if postName != "" {
            firstCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        }
        if tagsTextField.isEmpty == false, tagsTextField.hasText {
            secondCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        } else {
            secondCellCheckPlaceHolder.image = UIImage(named: "waitingInputPlaceHolder")
        }
        if channelsSelectorTextField.isEmpty == false, channelsSelectorTextField.hasText {
            thirdCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        } else {
            thirdCellCheckPlaceHolder.image = UIImage(named: "waitingInputPlaceHolder")
        }
    }
    
    func setup() {
        
        modalView.backgroundColor = UIColor.fakeWhite
        
        addBottomBorders(view: firstCellView)
        addBottomBorders(view: secondCellVIew)
        
        tagsTextField.placeholder = "Adicionar Tags"
        
        channelsSelectorTextField.placeholder = "Adicionar Canais"
        
        addPostButton.backgroundColor = UIColor.main
        
        if postName != "" {
            postNameTextField.placeholder = postName
            firstCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        } else {
            postNameTextField.placeholder = "Adicionar Titutlo"
        }        
    }
    
    func setupDelegates() {
        postNameTextField.delegate = self
        tagsTextField.delegate = self
        channelsSelectorTextField.delegate = self
    }
    
    func createPost() {
        guard let viewModel = viewModel else { return }
        guard let postName = postName else { return }
        guard let postBody = postBody else { return }
        guard let tags = tagsTextField.text?.prefix(3) else { return }
        if postNameTextField.text == nil {
            viewModel.title = postName
        } else {
            viewModel.title = postNameTextField.text ?? ""
        }
        viewModel.body = postBody
        viewModel.tags = tags.components(separatedBy: ", ")
    }
    
    func addBottomBorders(view: UIView) {
        let thickness: CGFloat = 1.0
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.view.frame.size.height - thickness, width:self.view.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.fakeBlack.cgColor
        view.layer.addSublayer(bottomBorder)
    }
    
    func setupCheck() {
        if postNameTextField.isEmpty == false, postNameTextField.hasText {
            firstCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
        }
        if tagsTextField.isEmpty == false, tagsTextField.hasText {
            secondCellCheckPlaceHolder.image = UIImage(named: "checkPlaceHolder")
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
        viewModel?.create()
    }
}
