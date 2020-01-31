//
//  AddPostViewController.swift
//  noodles
//
//  Created by Pedro Henrique Guedes Silveira on 23/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    private let viewModel: AddPostViewModel
    
    private let bodyPlaceHolder = "Adicionar o texto"
        
    init(viewModel: AddPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AddPostViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavButton()
        setupTextField()
        setupTextView()
        bodyTextView.delegate = self
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == bodyTextView && textView.text == bodyPlaceHolder {
            moveCursorToStart(textView: textView)
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLenght = textView.text.utf16.count + text.utf16.count - range.length
        
        if newLenght > 0 {
            
            if textView == bodyTextView && textView.text == bodyPlaceHolder {
                
            applyNonPlaceholderStyle(textview: textView)
            textView.text = ""
            }
            return true
        } else {
            applyPlaceholderStyle(textview: textView, placeholderText: bodyPlaceHolder)
            moveCursorToStart(textView: textView)
        }
        return false
    }

    func setup() {
        view.backgroundColor = UIColor.fakeWhite
        
        titleTextField.textColor = UIColor.betaGray
        titleTextField.placeholder = "Insira um Titulo"

        bodyTextView.textColor = UIColor.gammaGray
    }
    
    func openModal() {
        guard let postName = titleTextField.text else {
            return
        }
        guard let postBody = bodyTextView.text else {
            return
        }
        let modalViewController = CreatePostViewController(viewModel: viewModel)
        modalViewController.postName = postName
        modalViewController.postBody = postBody
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
     }
    
    public func setupNavButton() {
        let addPostButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
        self.navigationItem.rightBarButtonItem = addPostButton
    }
    
    func setupTextField() {
        titleTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender: )))
    }
    
    func setupTextView() {
        bodyTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender: )))
        applyPlaceholderStyle(textview: bodyTextView, placeholderText: bodyPlaceHolder)
    }
    
    func applyPlaceholderStyle(textview: UITextView, placeholderText: String) {
      textview.textColor = UIColor.lightGray
      textview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(textview: UITextView) {
      textview.textColor = UIColor.darkText
      textview.alpha = 1.0
    }
    
    func moveCursorToStart(textView: UITextView) {
        DispatchQueue.main.async {
            textView.selectedRange = NSMakeRange(0, 0)
        }
    }

    @objc private func addPost() {
        openModal()
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
     
}
