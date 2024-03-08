//
//  Race.swift
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


// Вроде не нужна
struct Settings {
//    var gameSpeed: GameSpeed
//    var obstacle: Obstacle
//    var carColor: CarColor
    var race: Race
}

enum GameSpeed: CGFloat {
    case slow = 4.0
    case medium = 7.0
    case fast = 10.0
}

enum Obstacle: String {
    case tree = "tree"
    case bush = "bush"
    case without = "without"
}

enum CarColor: String {
    case carGreen = "greenCar"
    case carRed = "redCar"
    case carBlack = "blackCar"
}

enum Control {
    case tap
    case swipe
}

struct Race {
    var gameSpeed: GameSpeed
    var obstacleName: Obstacle
    var carColorName: CarColor
    var control: Control
}


