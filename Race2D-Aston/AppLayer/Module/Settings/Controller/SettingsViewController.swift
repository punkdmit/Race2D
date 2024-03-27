//
//  SettingsViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: Private properties
    
    private var user: User? = {
        let user = StorageService.shared.load()
        return user
    }()
    
    private lazy var settingsView: SettingsView = {
        let view = SettingsView()
        view.delegate = self
        return view
    }()
    
    private var newLabelText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: SettingsViewDelegate

extension SettingsViewController: SettingsViewDelegate {
    
    func didTapSaveSettingsButton(inputText: String?) {
        guard let user = user else { return }
        
        if let inputText = inputText, !inputText.isEmpty {
            user.name = inputText
        }
        StorageService.shared.save(user)
        self.setupUserInfo()
    }
    
    func carSettingsLeftButtonTapped() {
        guard let user = user else { return }
        let currentColor = user.raceSettings.carColorName
        var newColor: Race.CarColor
        switch currentColor {
        case .carBlue:
            newColor = .carRed
        case .carRed:
            newColor = .carGreen
        case .carGreen:
            newColor = .carBlue
        }
        newLabelText = newColor.label
        user.raceSettings.carColorName = newColor
        settingsView.carSettingsLabelText = newLabelText
    }
    
    func carSettingsRightButtonTapped() {
        guard let user = user else { return }
        let currentColor = user.raceSettings.carColorName
        var newColor: Race.CarColor
        switch currentColor {
        case .carGreen:
            newColor = .carRed
        case .carRed:
            newColor = .carBlue
        case .carBlue:
            newColor = .carGreen
        }
        newLabelText = newColor.label
        user.raceSettings.carColorName = newColor
        settingsView.carSettingsLabelText = newLabelText
    }
    
    func gameSpeedSettingsLeftButtonTapped() {
        guard let user = user else { return }
        let currentSpeed = user.raceSettings.gameSpeed
        var newSpeed: Race.GameSpeed
        switch currentSpeed {
        case .fast:
            newSpeed = .medium
        case .medium:
            newSpeed = .slow
        case .slow:
            newSpeed = .fast
        }
        newLabelText = newSpeed.label
        user.raceSettings.gameSpeed = newSpeed
        settingsView.gameSpeedSettingsLabelText = newLabelText
    }
    
    func gameSpeedSettingsRightButtonTapped() {
        guard let user = user else { return }
        let currentSpeed = user.raceSettings.gameSpeed
        var newSpeed: Race.GameSpeed
        switch currentSpeed {
        case .fast:
            newSpeed = .slow
        case .slow:
            newSpeed = .medium
        case .medium:
            newSpeed = .fast
        }
        newLabelText = newSpeed.label
        user.raceSettings.gameSpeed = newSpeed
        settingsView.gameSpeedSettingsLabelText = newLabelText
    }
    
    func obctacleSettingsLeftButtonTapped() {
        guard let user = user else { return }
        let currentObstacle = user.raceSettings.obstacleName
        var newObstacle: Race.Obstacle
        switch currentObstacle {
        case .bush:
            newObstacle = .tree
        case .tree:
            newObstacle = .bush
        }
        newLabelText = newObstacle.label
        user.raceSettings.obstacleName = newObstacle
        settingsView.obstacleSettingsLabelText = newLabelText
    }
    
    func obstacleSettingsRightButtonTapped() {
        guard let user = user else { return }
        let currentObstacle = user.raceSettings.obstacleName
        var newObstacle: Race.Obstacle
        switch currentObstacle {
        case .bush:
            newObstacle = .tree
        case .tree:
            newObstacle = .bush
        }
        newLabelText = newObstacle.label
        user.raceSettings.obstacleName = newObstacle
        settingsView.obstacleSettingsLabelText = newLabelText
    }
    
    func controlSettingsLeftButtonTapped() {
        guard let user = user else { return }
        let currentControl = user.raceSettings.control
        var newControl: Race.Control
        switch currentControl {
        case .swipe:
            newControl = .tap
        case .tap:
            newControl = .swipe
        }
        newLabelText = newControl.label
        user.raceSettings.control = newControl
        settingsView.controlSettingsLabelText = newLabelText
    }
    
    func controlSettingsRightButtonTapped() {
        guard let user = user else { return }
        let currentControl = user.raceSettings.control
        var newControl: Race.Control
        switch currentControl {
        case .tap:
            newControl = .swipe
        case .swipe:
            newControl = .tap
        }
        newLabelText = newControl.label
        user.raceSettings.control = newControl
        settingsView.controlSettingsLabelText = newLabelText
    }
}

//MARK: Private methods

private extension SettingsViewController {
    
    func setupUI() {
        configureLayout()
        setupUserInfo()
        setupSettings()
    }
    
    func configureLayout() {
        view.addSubview(settingsView)
        
        settingsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    func setupUserInfo() {
        guard let user = user else { return }
        settingsView.usernameLabelText = user.name
        settingsView.userImage = StorageService.shared.loadImage(by: (user.imageName ?? ""))
    }
    
    func setupSettings() {
        guard let user = user else { return }
        let currentColor = user.raceSettings.carColorName
        switch currentColor {
        case .carBlue:
            newLabelText = currentColor.label
        case .carRed:
            newLabelText = currentColor.label
        case .carGreen:
            newLabelText = currentColor.label
        }
        settingsView.carSettingsLabelText = newLabelText
        
        let currentSpeed = user.raceSettings.gameSpeed
        switch currentSpeed {
        case .fast:
            newLabelText = currentSpeed.label
        case .medium:
            newLabelText = currentSpeed.label
        case .slow:
            newLabelText = currentSpeed.label
        }
        settingsView.gameSpeedSettingsLabelText = newLabelText
        
        let currentObstacle = user.raceSettings.obstacleName
        switch currentObstacle {
        case .bush:
            newLabelText = currentObstacle.label
        case .tree:
            newLabelText = currentObstacle.label
        }
        settingsView.obstacleSettingsLabelText = newLabelText
        
        let currentControl = user.raceSettings.control
        switch currentControl {
        case .tap:
            newLabelText = currentControl.label
        case .swipe:
            newLabelText = currentControl.label
        }
        settingsView.controlSettingsLabelText = newLabelText
    }
}

