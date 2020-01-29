//
//  Coordinator.swift
//  noodles
//
//  Created by Artur Carneiro on 24/01/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navController: UINavigationController { get set }

    func start()
}
