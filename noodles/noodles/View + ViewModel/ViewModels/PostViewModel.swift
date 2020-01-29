//
//  PostsViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol PostViewModelDelegate: class {
    func reloadUI()
}

final class PostViewModel {
    private let interactor: PostInteractor
    private let coordinator: Coordinator
    private var model: PostModel {
        didSet {
            delegate?.reloadUI()
        }
    }

    weak var delegate: PostViewModelDelegate?

    init(interactor: PostInteractor, coordinator: Coordinator, model: PostModel) {
        self.interactor = interactor
        self.coordinator = coordinator
        self.model = model
    }

    // MARK: Public attributes
    /*
     Public attributes can be accessed by the view and should be in a ready-to-use format, such as Strings, Bools, Ints, Doubles, etc.
     */
    public var title: String {
        return model.title
    }

    public var body: String {
        return model.body
    }

    public var tags: [String] {
        return model.tags
    }

    public var validated: Bool {
        return model.validated
    }

    public var readByNames: [String] {
        return getReadByNames()
    }

    public var channelsName: [String] {
        return getChannelsName()
    }

    // MARK: Private attributes
    /*
     Private attributes can't be accessed by the view directly.
     To access any private attribute, the view should use the available public functions that return a ready-to-use attribute.
     */
    private var createdAt: Date? {
        return model.createdAt ?? nil
    }

    private var id: String {
        return model.id
    }

    private var readBy: [UserModel]? {
        return model.readBy ?? nil
    }

    private var editedAt: Date? {
        return model.editedAt ?? nil
    }

    private var author: UserModel? {
           return model.author ?? nil
    }

    private var channels: [ChannelModel]? {
        return model.channels
    }

    private var readByIDs = [String]()

    private var channelsID = [String]()

    // MARK: Public functions
    public func authorName() -> String {
        return author?.name ?? ""
    }

    public func authorID() -> String {
        return author?.id ?? ""
    }

    public func creationDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let createdAt = createdAt {
            let date = dateFormatter.string(from: createdAt)
            return date
        }
        return ""
    }

    public func lastEditedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let editedAt = editedAt {
            let date = dateFormatter.string(from: editedAt)
            return date
        }
        return ""
    }

    public func bookmark() {

    }

    // MARK: Private functions
    private func getReadByNames() -> [String] {
        readByIDs.removeAll(keepingCapacity: false)
        var names = [String]()
        if let readBy = readBy {
            for user in readBy {
                names.append(user.name)
                readByIDs.append(user.id)
            }
        }
        return names
    }

    private func getChannelsName() -> [String] {
        channelsID.removeAll(keepingCapacity: false)
        var names = [String]()
        if let channels = channels {
            for channel in channels {
                names.append(channel.name)
                channelsID.append(channel.id)
            }
        }
        return names
    }
    
}
