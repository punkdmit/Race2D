//
//  ViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 18.02.2024.
//

import UIKit

class MainViewController: GenericViewController<MainView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: Internal methods

extension MainViewController {
    
    @objc private func gameTapped(_ sender: UIButton) {
        push(RaceViewController())
    }
    
    @objc func settingsTapped(_ sender: UIButton) {
        push(SettingsViewController())
    }
    
    @objc func recordsTapped(_ sender: UIButton) {
        push(RecordsViewController())
    }
}

//MARK: Private methods

private extension MainViewController {
    
    func setup() {
        rootView.startButton.addTarget(self, action: #selector(gameTapped), for: .touchUpInside)
        rootView.settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        rootView.recordsButton.addTarget(self, action: #selector(recordsTapped), for: .touchUpInside)
    }
}
