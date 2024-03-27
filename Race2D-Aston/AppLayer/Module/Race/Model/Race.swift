//
//  Race.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 23.02.2024.
//

import Foundation
import UIKit

struct Race: Codable {
    var gameSpeed: GameSpeed
    var obstacleName: Obstacle
    var carColorName: CarColor
    var control: Control
    
    enum GameSpeed: CGFloat, Codable {
        case slow = 6.0
        case medium = 8.0
        case fast = 10.0
        
        var label: String {
            switch self {
            case .fast:
                return "Сложно"
            case .medium:
                return "Средне"
            case .slow:
                return "Легко"
            }
        }
    }

    enum Obstacle: String, Codable {
        case tree = "Tree"
        case bush = "Bush"
        
        var label: String {
            switch self {
            case .tree:
                return "Дерево"
            case .bush:
                return "Куст"
            }
        }
    }

    enum CarColor: String, Codable {
        case carGreen = "Green car"
        case carRed = "Red car"
        case carBlue = "Blue car"
        
        var label: String {
            switch self {
            case .carBlue:
                return "Голубая машина"
            case .carGreen:
                return "Зеленая машина"
            case .carRed:
                return "Красная машина"
            }
        }
    }

    enum Control: String, Codable {
        case tap = "Tap"
        case swipe = "Swipe"
        
        var label: String {
            switch self {
            case .swipe:
                return "Свайп"
            case .tap:
                return "Касание"
            }
        }
    }
}


