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
    let TAGSCOLLECTIONVIEWCELL = "TagsCollectionViewCell"

    let viewModel: PostViewModel
    let coordinator: Coordinator

    init(viewModel: PostViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
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
        postTitle.text = viewModel.title
        postAuthor.text = viewModel.authorName()
        text.text = viewModel.body
        tagsCollectionView.dataSource = self
    }
}

extension PresentPostViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TAGSCOLLECTIONVIEWCELL, for: indexPath) as? TagsCollectionViewCell ?? TagsCollectionViewCell()

        cell.tagTitle.text = viewModel.tags[indexPath.row]

        return cell
    }
}
