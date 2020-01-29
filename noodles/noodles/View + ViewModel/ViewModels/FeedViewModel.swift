//
//  FeedViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol FeedViewModelDelegate: class {
    func reloadUI()
}

final class FeedViewModel: ViewModel {
    private let interactor: PostInteractor
    private let coordinator: Coordinator
    private var models = [PostModel]() {
        didSet {
            delegate?.reloadUI()
        }
    }

    weak var delegate: FeedViewModelDelegate?

    init(interactor: PostInteractor, coordinator: Coordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
        fetch()
    }

    public func fetch() {
        interactor.fetchAll(from: .cloudkit) { [weak self] (posts) in
            if let posts = posts {
                DispatchQueue.main.async {
                    self?.models = posts
                }
            }
        }
    }

    // MARK: Public functions

    /*
     Public functions to access data from models in a ready-to-use format.
     It is safe to assume that no Post will be without an Author.
     */
    public func title(at index: Int) -> String {
        return models[index].title
    }

    public func author(at index: Int) -> String {
        if let author = models[index].author {
            return author.name
        }
        return ""
    }

    public func tags(at index: Int) -> [String] {
        return models[index].tags
    }

    public func creationDate(at index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = models[index].createdAt {
            return dateFormatter.string(from: date)
        }
        return ""
    }

    public func bookmarked(at index: Int) -> Bool {
        // Bookmarks are not yet implemented
        return false
    }

    /*
     The public functions below are all to be used by the view to either build the
     layout or respond to the user's input
     */
    public func numberOfRows() -> Int {
        return models.count
    }

    public func selected(index: Int) {
        // Coordinator -> Single Post
    }

    public func bookmark(index: Int) {
        // Bookmarks are not yet implemented
    }
}
