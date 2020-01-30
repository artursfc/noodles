//
//  ProfileViewModel.swift
//  noodles
//
//  Created by Artur Carneiro on 26/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

protocol ProfileViewModelDelegate: class {
    func reloadUI()
}

final class ProfileViewModel {
    private let interactor: UserInteractor
    private let coordinator: Coordinator
    private var model: UserModel {
        didSet {
            delegate?.reloadUI()
        }
    }

    weak var delegate: ProfileViewModelDelegate?

    init(interactor: UserInteractor, coordinator: Coordinator, model: UserModel) {
        self.interactor = interactor
        self.coordinator = coordinator
        self.model = model
    }

    // MARK: Public attributes
    /*
     Public attributes can be accessed by the view and should be in a ready-to-use format, such as Strings, Bools, Ints, Doubles, etc.
     */
    public var name: String {
        return model.name
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

    private var editedAt: Date? {
        return model.editedAt ?? nil
    }

    private var rank: RankModel? {
        return model.rank
    }

    // MARK: Public functions
    public func rankName() -> String {
        if let rank = rank {
            return rank.title
        }
        return ""
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

    public func rankInfo() {
        // Coordinator -> Go to Rank info page passing the rank model
    }
}
