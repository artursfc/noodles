//
//  PresentPostViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 28/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class PresentPostViewController: UIViewController {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var text: UITextView!

    let viewModel: PostViewModel

    init(viewModel: PostViewModel) {
        self.viewModel = viewModel
         super.init(nibName: "PresentPostViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresentPost()
    }

    func setupPresentPost() {
    

    }
}
