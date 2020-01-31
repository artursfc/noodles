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
    private let coordinator: MainCoordinator
    private let channel: ChannelModel

    weak var delegate: AddPostViewModelDelegate?

    init(postInteractor: PostInteractor, coordinator: MainCoordinator, channel: ChannelModel) {
        self.postInteractor = postInteractor
        self.coordinator = coordinator
        self.channel = channel
    }

    // MARK: Public attributes
    public var title: String = ""

    public var body: String = ""

    public var tags = [String]()

    // MARK: Private attributes
    private var validated: Bool = true

    // MARK: Public functions
    public func create() {
        if !title.isEmpty && !body.isEmpty {
            delegate?.accept(field: .post)
            let post = PostModel(id: "", title: title, body: body, author: nil, tags: tags, readBy: nil, validated: validated, createdAt: nil, editedAt: nil, channels: [channel])
            postInteractor.save(post: post) { (bool) in
                if bool {
                    //Saved
                } else {
                    //Failed
                }
            }
        } else {
            delegate?.reject(field: .post)
        }
    }
    
    public func goBackToChannel() {
        coordinator.goBack()
    }
}
