//
//  MainView.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import Kingfisher
import SnapKit
import UIKit

//MARK: MainViewDelegate

protocol MainViewDelegate: AnyObject {
    func didTapStartButton()
    func didTapSettingsButton()
    func didTapRecordsButton()
}

class MainView: UIView {
    
    //MARK: Constants
    
    private enum Constants {
        static let stackWidthMultipliedBy = 0.8
        static let startButtonTitle = "Start"
        static let settingsButtonTitle = "Settings"
        static let recordsButtonTitle = "Records"
        static let backgroundImageURL = URL(
            string: "https://i.pinimg.com/originals/01/36/6a/01366accc76cd523f100873afd6930e2.jpg"
        )
    }
    
    // MARK: Internal properties
    
    weak var delegate: MainViewDelegate?
    
    // MARK: Private properties
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.kf.setImage(with: Constants.backgroundImageURL)
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = AppConstants.normalSpacing
        return stack
    }()
    
    private lazy var startButton: CustomButton = {
        let button = CustomButton()
        button.title = Constants.startButtonTitle
        button.addTarget(
            self,
            action: #selector(didTapStartButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var settingsButton: CustomButton = {
        let button = CustomButton()
        button.title = Constants.settingsButtonTitle
        button.addTarget(
            self,
            action: #selector(didTapSettingsButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private  lazy var recordsButton: CustomButton = {
        let button = CustomButton()
        button.title = Constants.recordsButtonTitle
        button.addTarget(
            self,
            action: #selector(didTapRecordsButton),
            for: .touchUpInside
        )
        return button
    }()
    
    //MARK: Inizialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Action

@objc
private extension MainView {
    
    func didTapStartButton(_ sender: UIButton) {
        delegate?.didTapStartButton()
    }
    
    func didTapSettingsButton(_ sender: UIButton) {
        delegate?.didTapSettingsButton()
    }
    
    func didTapRecordsButton(_ sender: UIButton) {
        delegate?.didTapRecordsButton()
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
