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
    private let viewModel: AddPostViewModel
        
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
    func setup() {
        view.backgroundColor = UIColor.fakeWhite
        
        titleTextField.textColor = UIColor.betaGray
        titleTextField.placeholder = "Insira um Titulo"

        bodyTextView.textColor = UIColor.gammaGray
    }
    
    @objc func openModal() {
        guard let postName = titleTextField.text else { return }
        guard let postBody = bodyTextView.text else { return }
        let modalViewController = CreatePostViewController()
        modalViewController.postName = postName
        modalViewController.postBody = postBody
        modalViewController.viewModel = viewModel
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
