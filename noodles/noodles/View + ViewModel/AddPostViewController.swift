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
    
//    let viewModel = PostModel(id: "id", uniqueID: "uniqueID", title: "title", body: "Body", author: "author", authorID: UserModel(id: "id1", name: "name", canEdit: <#T##[ChannelModel]#>, canView: <#T##[ChannelModel]#>, canCreateChannel: true), tags: ["tag 1", "tag 2"], readBy: [UserModel(id: "id1", name: "name", canEdit: <#T##[ChannelModel]#>, canView: <#T##[ChannelModel]#>, canCreateChannel: true)], validated: true, createdAt: 02.01.2020, editedAt: 02.02.2020, channels: [ChannelModel(id: "channelId", posts: [], cratedBy: <#T##UserModel#>, canBeEditedBy: <#T##[RankModel]#>, canBeViewedBy: <#T##[RankModel]#>, createdAt: <#T##Date#>, editedAt: <#T##Date#>)])    
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setup() {
        view.backgroundColor = UIColor.fakeWhite
        
        titleTextField.textColor = UIColor.betaGray
        titleTextField.placeholder = "Insira um Titulo"
        
        bodyTextView.textColor = UIColor.gammaGray
        
        
    }
    
}
