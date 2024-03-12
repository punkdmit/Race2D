//
//  StorageService.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 09.03.2024.
//

import Foundation
import UIKit

private extension String {
    static let key = "user"
}

final class StorageService {
    
    // MARK: Constants
    
    private enum Constants {
        static let userImageName = "avatar"
    }
    

    
    static let shared = StorageService()
    private init() {}
    
    func initializeDefaultSettings() {
//        UserDefaults.standard.removeObject(forKey: .key)
        if load() == nil {
            let image = UIImage(named: Constants.userImageName) ?? UIImage()
            let imageName = try? StorageService.shared.saveImage(image)
            let defaultSettings = RaceSettings(gameSpeed: .fast, obstacleName: .tree, carColorName: .carRed, control: .swipe)
            let user = User(name: nil, photo: imageName, race: defaultSettings, records: [])
            save(user)
        }
    }
    
    func save(_ user: User) {
        let data = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: .key)
    }
    
    func load() -> User? {
        guard let data = UserDefaults.standard.value(forKey: .key) as? Data else { return nil }
        
        let user = try? JSONDecoder().decode(User.self, from: data)
        return user
    }
    
    func saveImage(_ image: UIImage) throws -> String? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let name = UUID().uuidString
        let url = directory.appendingPathComponent(name)
        
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(atPath: url.path)
        }
        
        try data.write(to: url)
        return name
    }
    
    func loadImage(by name: String) -> UIImage? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let url = directory.appendingPathComponent(name)
        return UIImage(contentsOfFile: url.path)
    }
}
