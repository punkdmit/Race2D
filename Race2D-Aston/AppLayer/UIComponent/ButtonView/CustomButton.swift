//
//  CustomButton.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 18.02.2024.
//

import UIKit

class CustomButton: UIButton {
    
    // MARK: Constants
    
    private enum Constants {
        static let borderWidth = 1.0
        static let height: CGFloat = 48.0
        static let cornerRadiusDivider: CGFloat = 2
    }
    
    // MARK: Internal properties
    
    var title: String = "" {
        didSet {
            setTitle(title)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted
            ? Assets.Colors.red
            : Assets.Colors.redLight
        }
    }
    
    // MARK: Inititalization
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Internal methods

extension CustomButton {
    
    // MARK: Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / Constants.cornerRadiusDivider
    }
}

// MARK: Private methods

private extension CustomButton {
    
    func setupUI() {
        self.layer.borderWidth = Constants.borderWidth
        self.layer.borderColor = Assets.Colors.red.cgColor
        self.backgroundColor = Assets.Colors.redLight
        configureLayout()
    }
    
    func configureLayout() {
        snp.makeConstraints {
            $0.height.equalTo(Constants.height)
        }
    }
    
    func setTitle(_ title: String) {
        setAttributedTitle(
            NSAttributedString(
                string: title,
                attributes: [.font: SemiboldFont.h2, .foregroundColor: Assets.Colors.red]
            ),
            for: .normal
        )
        setAttributedTitle(
            NSAttributedString(
                string: title,
                attributes: [.font: SemiboldFont.h2, .foregroundColor: Assets.Colors.redLight]
            ),
            for: .highlighted
        )
    }
}
