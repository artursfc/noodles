//
//  AddPostViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 28/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol AddPostViewModelDelegate: class {
    func reject()
    func accept()
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

    public var author: String = ""

    public var tags = [String]()

    // MARK: Private attributes
    private var validated: Bool = false

    /*
     var id: String
     var title: String
     var body: String
     var author: UserModel?
     var tags: [String]
     var readBy: [UserModel]?
     var validated: Bool
     var createdAt: Date?
     var editedAt: Date?
     var channels: [ChannelModel]?
     */

    // MARK: Public functions
    public func create() {
        if !title.isEmpty && !body.isEmpty {
            delegate?.accept()
        } else {
            delegate?.reject()
        }
    }
}
