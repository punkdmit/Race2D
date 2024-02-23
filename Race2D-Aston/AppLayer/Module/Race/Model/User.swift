//
//  User.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 23.02.2024.
//

import Foundation
import UIKit

struct User {
    var name: String
    var photo: UIImage
    var records: [Records]
}

struct Records {
    var user: User
    var count: Int
    var date: Date
}

struct Game {
    enum GameSpeed { case slow, medium, fast }
    enum Obstacle { case tree, bush, without }
    enum CarColor { case carGreen, carBlue, carBlack }
    var gameSpeed: GameSpeed
    var obstacle: Obstacle
    var carColor: CarColor
}


