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

final class AddPostViewModel: ViewModel {
    private let postInteractor: PostInteractor
    private let coordinator: Coordinator

    weak var delegate: AddPostViewModelDelegate?

    init(postInteractor: PostInteractor, coordinator: Coordinator) {
        self.postInteractor = postInteractor
        self.coordinator = coordinator
    }

    // MARK: Public attributes
    public var title: String = ""

    public var body: String = ""

    public var tags = [String]()

    // MARK: Private attributes
    private let defaults = UserDefaults.standard

    private var validated: Bool = true

    private var author: String {
        return defaults.string(forKey: "UserID") ?? ""
    }

    // MARK: Public functions
    public func create() {
        if !title.isEmpty && !body.isEmpty {
            delegate?.accept(field: .post)
        } else {
            delegate?.reject(field: .post)
        }
    }
}
