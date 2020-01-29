//
//  AddPostViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 28/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

enum AddPostField {
    case title
    case body
    case post
}

protocol AddPostViewModelDelegate: class {
    func reject(field: AddPostField)
    func accept(field: AddPostField)
}

final class AddPostViewModel {
    private let postInteractor: PostInteractor

    weak var delegate: AddPostViewModelDelegate?

    init(postInteractor: PostInteractor) {
        self.postInteractor = postInteractor
    }

    // MARK: Public attributes
    public var title: String = ""

    public var body: String = ""

    public var tags = [String]()

    // MARK: Private attributes
    private var validated: Bool = true

    private var author: String = ""

    // MARK: Public functions
    public func create() {
        if !title.isEmpty && !body.isEmpty {
            delegate?.accept(field: .post)
        } else {
            delegate?.reject(field: .post)
        }
    }
}
