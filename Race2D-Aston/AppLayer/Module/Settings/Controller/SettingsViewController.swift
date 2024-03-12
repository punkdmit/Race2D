//
//  SettingsViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: Private properties
    
    private let user = {
        let user = StorageService.shared.load()
        return user
    }
    
    private lazy var settingsView: SettingsView = {
        let view = SettingsView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

//MARK: SettingsViewDelegate

extension SettingsViewController: SettingsViewDelegate {
    
    func didTapSaveButton() {
        
    }
    
    func carSettingsLeftButtonTapped() {
        
    }
    
    func carSettingsRightButtonTapped() {
        guard let user = user() else { return }
           let currentColor = user.raceSettings.carColorName
           let newColor: RaceSettings.CarColor
           switch currentColor {
           case .carGreen:
               newColor = .carRed
           case .carRed:
               newColor = .carBlack
           case .carBlack:
               newColor = .carGreen
           }
           user.raceSettings.carColorName = newColor
           settingsView.carSettingsLabelText = newColor.rawValue
    }
    
    func gameSpeedSettingsLeftButtonTapped() {
        
    }
    
    func gameSpeedSettingsRightButtonTapped() {
        
    }
    
    func obctacleSettingsLeftButtonTapped() {
        
    }
    
    func obstacleSettingsRightButtonTapped() {
        
    }
    
    func controlSettingsLeftButtonTapped() {
        
    }
    
    func controlSettingsRightButtonTapped() {
        
    }
}

//MARK: Private methods

private extension SettingsViewController {
    
    func setupUI() {
        configureLayout()
        setupSettings()
        setupUserInfo()
    }
    
    func configureLayout() {
        view.addSubview(settingsView)
        
        settingsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupUserInfo() {
//        settingsView.usernameCustomTextField.placeholderText = ""
        settingsView.userImage = StorageService.shared.loadImage(by: (user()?.photo ?? ""))
    }
    
    func setupSettings() {
        settingsView.carSettingsLabelText = user()?.raceSettings.carColorName.rawValue
        settingsView.gameSpeedSettingsLabelText = String(describing: user()?.raceSettings.gameSpeed.rawValue)
        settingsView.obstacleSettingsLabelText = user()?.raceSettings.obstacleName.rawValue
        settingsView.controlSettingsLabelText = user()?.raceSettings.control.rawValue
    }
}

