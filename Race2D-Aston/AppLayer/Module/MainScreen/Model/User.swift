//
//  User.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 14.03.2024.
//

import Foundation

final class User: Codable {
    var name: String?
    var imageName: String?
    var raceSettings: Race
    var records: [Record?]
    
    init(name: String?, photo: String?, race: Race, records: [Record?]) {
        self.name = name
        self.imageName = photo
        self.raceSettings = race
        self.records = records
    }
}
