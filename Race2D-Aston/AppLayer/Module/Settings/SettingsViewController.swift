//
//  SettingsViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var settingsView: SettingsView = {
        let view = SettingsView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .red
    }

}

//MARK: Private methods

private extension SettingsViewController {
    
    func setupUI() {
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(settingsView)
        
        settingsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
           
        }
    }
}

