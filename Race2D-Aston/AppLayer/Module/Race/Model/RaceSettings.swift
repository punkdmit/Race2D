//
//  Race.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 23.02.2024.
//

import Foundation
import UIKit

final class User: Codable {
    var name: String?
    var photo: String?
    var raceSettings: RaceSettings
    var records: [Records?]
    
    init(name: String?, photo: String?, race: RaceSettings, records: [Records?]) {
        self.name = name
        self.photo = photo
        self.raceSettings = race
        self.records = records
    }
}

struct Records: Codable {
    var count: Int
    var date: Date
}

struct RaceSettings: Codable {
    var gameSpeed: GameSpeed
    var obstacleName: Obstacle
    var carColorName: CarColor
    var control: Control
    
    enum GameSpeed: CGFloat, Codable {
        case slow = 4.0
        case medium = 7.0
        case fast = 10.0
    }

    enum Obstacle: String, Codable {
        case tree = "Tree"
        case bush = "Bush"
        case without = "Without"
    }

    enum CarColor: String, Codable {
        case carGreen = "Green car"
        case carRed = "Red car"
        case carBlack = "Black car"
    }

    enum Control: String, Codable {
        case tap = "Tap"
        case swipe = "Swipe"
    }
}


