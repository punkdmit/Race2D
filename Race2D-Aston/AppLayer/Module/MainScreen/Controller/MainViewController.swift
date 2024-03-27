//
//  ViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 18.02.2024.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: Private properties
    
    private lazy var mainView: MainView = {
        let view = MainView()
        view.delegate = self
        return view
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: MainViewDelegate

extension MainViewController: MainViewDelegate {
    
    func didTapStartButton() {
        push(RaceViewController())
    }
    
    func didTapSettingsButton() {
        push(SettingsViewController())
    }
    
    func didTapRecordsButton() {
        push(RecordsViewController())
    }
    
}

//MARK: Private methods

private extension MainViewController {
    
    func setupUI() {
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
