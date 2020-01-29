//
//  BookmarksViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 26/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol BookmarksViewModelDelegate: class {
    func reloadUI()
}

final class BookmarksViewModel: ViewModel {
    private let interactor: PostInteractor
    private let coordinator: Coordinator
    private var models = [PostModel]() {
        didSet {
            delegate?.reloadUI()
        }
    }
    private var bookmarks = [String]() {
        didSet {
            updateModel()
        }
    }

    weak var delegate: BookmarksViewModelDelegate?

    init(interactor: PostInteractor, coordinator: Coordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
        fetch()
    }

    private let defaults = UserDefaults.standard

    // MARK: Public functions

    public func fetch() {
        interactor.bookmarks { [weak self] (result) in
            if let bookmarks = result {
                self?.bookmarks = bookmarks
            }
        }
    }

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

    /*
     The public functions below are all to be used by the view to either build the
     layout or respond to the user's input
     */
    public func numberOfRows() -> Int {
        return models.count
    }

    public func selected(at index: Int) {
        // Coordinator -> Single Post
    }

    // MARK: Private function
    
    private func updateModel() {
        interactor.fetch(with: bookmarks, from: .cloudkit) { [weak self] (result) in
            if let posts = result {
                DispatchQueue.main.async {
                    self?.models = posts
                }
            }
        }
    }
}
