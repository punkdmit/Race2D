//
//  ViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 18.02.2024.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: <#extension#>
    
    private lazy var mainView: MainView = {
        let view = MainView()
        view.delegate = self
        return view
    }()
    
//    override func loadView() {
//        let mainView = MainView()
//        mainView.delegate = self
//        view = mainView
//    }
    
    // MARK: <#extension#>
    
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
