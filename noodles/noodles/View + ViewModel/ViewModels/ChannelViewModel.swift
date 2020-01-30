//
//  ChannelViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol ChannelViewModelDelegate: class {
    func reloadUI()
}

final class ChannelViewModel {
    private let interactor: ChannelInteractor
    private let coordinator: MainCoordinator
    private var model: ChannelModel {
        didSet {
            delegate?.reloadUI()
        }
    }

    weak var delegate: ChannelViewModelDelegate?

    init(interactor: ChannelInteractor, model: ChannelModel, coordinator: MainCoordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
        self.model = model
    }

    public func fetch() {
        interactor.fetch(with: model.id, from: .cloudkit) { [weak self] (channel) in
            if let channel = channel {
                DispatchQueue.main.async {
                    self?.model = channel
                }
            }
        }
    }

    // MARK: Public functions
    /*
     The public functions below should be used to get access to each post info.
     They should return a ready-to-use value.
     */
    public func title(at index: Int) -> String {
        if let post = model.posts?[index] {
            return post.title
        }
        return ""
    }

    public func author(at index: Int) -> String {
        if let post = model.posts?[index] {
            if let author = post.author {
                return author.name
            }
        }
        return ""
    }

    public func tags(at index: Int) -> [String] {
        if let post = model.posts?[index] {
            return post.tags
        }
        return []
    }

    public func creationDate(at index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let post = model.posts?[index] {
            if let date = post.createdAt {
                return dateFormatter.string(from: date)
            }
        }
        return ""
    }

    /*
     The public functions below should be used by the view to either build the layout
     or respond to the user's input.
     */
    public func numberOfRows() -> Int {
        return model.posts?.count ?? 0
    }

    /*
     Use this function to choose which post to look at.
    */
    public func selected(at index: Int) {
        if let posts = model.posts {
            coordinator.presentPost(postModel: posts[index])
        }
    }

    public func addPost() {
        coordinator.addPost(to: model)
    }
}
