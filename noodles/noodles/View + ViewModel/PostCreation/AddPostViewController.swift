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
    weak var delegate: AddPostDelegate?
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
    func createPost() {
        viewModel.title = titleTextField.text ?? ""
        viewModel.body = bodyTextView.text
        postName = titleTextField.text
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
    
    func setupGesture() {
        let openModalGesture = UITapGestureRecognizer(target: self, action: #selector(openModal))
        testView.addGestureRecognizer(openModalGesture)
    }
    
    @objc func openModal(){
         guard let postName = postName else {return}
        delegate?.receiveName(postName: postName)
        
//         delegate?.receivePlate(restaurantName: restaurantName ?? String(), plate: plate)
     }
     
    
}

extension AddPostViewController: AddPostDelegate {
    /**
     Function that receive the post name
     */
    func receiveName(postName: String) {
        let modalViewController = CreatePostViewController()
        modalViewController.delegate = self
        modalViewController.postName = postName
        modalViewController.modalPresentationStyle = .overCurrentContext
//        let modalViewController = CreatePostViewController()
//        let postTextField = modalViewController.postNameTextField.placeholder
//        if postTextField != nil {
//            postName = postTextField
//        } else {
//            postName = ""
//        }
//        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
}
