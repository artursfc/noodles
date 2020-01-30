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
    var postBody: String?
    weak var addPostDelegate: AddPostDelegate?
    private let viewModel: AddPostViewModel
    
    @IBOutlet weak var testView: UIView!
    
    init(viewModel: AddPostViewModel){
        self.viewModel = viewModel
        super.init(nibName: "AddPostViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    /**
     Function that create the post
     */
    func setupPostInformation() {
        postName = titleTextField.text
        postBody = bodyTextView.text
    }
    /**
     Function that setup the ui elements of AddSetup screen
     */
    func setup() {
        view.backgroundColor = UIColor.fakeWhite
        
        titleTextField.textColor = UIColor.betaGray
        titleTextField.placeholder = "Insira um Titulo"

        bodyTextView.textColor = UIColor.gammaGray
    }
    
    @objc func openModal() {
        guard let postName = postName else { return }
        guard let postBody = postBody else { return }
        addPostDelegate?.receivePost(postName: postName, postBody: postBody)
        let modalViewController = CreatePostViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
     }
    
    func setupNavController() {
        let nextItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(openModal))
        let navItem = UINavigationItem(title: "Next")
        navItem.rightBarButtonItem = nextItem
        navigationController?.navigationBar.setItems([navItem], animated: false)
    }
     
    
}

//extension AddPostViewController: AddPostDelegate {    
//    /**
//     Function that receive the post name
//     */
//    func receivePost(postName: String, postBody: String) {
//        let modalViewController = CreatePostViewController()
//        modalViewController.delegate = self
//        modalViewController.postName = postName
//        modalViewController.modalPresentationStyle = .overCurrentContext
//        present(modalViewController, animated: true, completion: nil)
//    }
//}
