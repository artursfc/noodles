//
//  AddPostViewController.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    var postName: String?
    
    var viewModel = PostModel(id: "id", title: "title", body: "body", author: nil, tags: ["tag1", "tag2"], readBy: [], validated: true, createdAt: nil, editedAt: nil, channels: [])
    
    init(viewModel: PostModel) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feed()
        setup()
        
    }
    
    func feed() {
        viewModel.title = titleTextField.text ?? ""
        viewModel.body = bodyTextView.text
        postName = titleTextField.text
    }
    
    func setup() {
        view.backgroundColor = UIColor.fakeWhite
        
        titleTextField.textColor = UIColor.betaGray
        titleTextField.placeholder = "Insira um Titulo"
        
        bodyTextView.textColor = UIColor.gammaGray
        
    }
    
}

extension CreatePostViewController: AddPostDelegate {
    
    func receiveName(postName: String) {
        var viewModel = PostModel(id: "id", title: "title", body: "body", author: nil, tags: ["tag1", "tag2"], readBy: [], validated: true, createdAt: nil, editedAt: nil, channels: [])
        let modalViewController = CreatePostViewController(viewModel: viewModel)
        modalViewController.postNameTextField.placeholder = postName
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
}
