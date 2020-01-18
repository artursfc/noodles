//
//  ProfileViewController.swift
//  noodles
//
//  Created by Eloisa Falcão on 15/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    var cornerRadius: CGFloat = 20.0

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var job: UIButton!

    @IBOutlet weak var profileJob: UILabel!
    @IBOutlet weak var profileEmail: UILabel!
    @IBOutlet weak var profileCountry: UILabel!
    @IBOutlet weak var profileState: UILabel!
    @IBOutlet weak var profileCity: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        view.backgroundColor = UIColor.fakeWhite

        backgroundView.backgroundColor = UIColor.fakeBlack

        profileBackgroundView.layer.cornerRadius = cornerRadius
        profileBackgroundView.backgroundColor = UIColor.fakeWhite

        profilePicture.layer.cornerRadius = cornerRadius
    }
}
