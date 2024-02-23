//
//  MainView.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import Kingfisher
import SnapKit
import UIKit

class MainView: UIView {
    
    //MARK: Constants
    
    private enum Constants {
        static let stackWidthMultipliedBy = 0.8
        static let startButtonTitle = "Start"
        static let settingsButtonTitle = "Settings"
        static let recordsButtonTitle = "Records"
        static let backgroundImageURL = "https://i.pinimg.com/originals/01/36/6a/01366accc76cd523f100873afd6930e2.jpg"
    }
    
    lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        let url = URL(string: Constants.backgroundImageURL)
        image.kf.setImage(with: url)
        image.contentMode = .scaleAspectFill
        return image
    }()

    
    lazy var startButton: CustomButton = {
        let button = CustomButton()
        button.title = Constants.startButtonTitle
        return button
    }()
    
    lazy var settingsButton: CustomButton = {
        let button = CustomButton()
        button.title = Constants.settingsButtonTitle
        return button
    }()
    
    lazy var recordsButton: CustomButton = {
        let button = CustomButton()
        button.title = Constants.recordsButtonTitle
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = AppConstants.normalSpacing
        return stack
    }()
    
    //MARK: Inizialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
       
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: Private methods

private extension MainView {
    
    func setupUI() {
        configureLayout()
    }
    
    func configureLayout() {
        insertSubview(backgroundImageView, at: 0)
        addSubview(stackView)
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(settingsButton)
        stackView.addArrangedSubview(recordsButton)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(Constants.stackWidthMultipliedBy)
        }
    }
}
