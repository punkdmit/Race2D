//
//  CustomTextField.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 18.02.2024.
//

import SnapKit
import UIKit

//MARK: CustomTextFieldDelegate

protocol CustomTextFieldDelegate: AnyObject {
    func textFieldDidBeginEditing()
    func textFieldDidEndEditing()
    func textFieldShouldBeginEditing()
    func textField()
    func textFieldShouldClear()
    func textFieldShouldEndEditing()
    func textFieldShouldReturn()
}

//MARK: CustomTextField class

final class CustomTextField: UITextField {
    
    //MARK: Constants
    
    private enum Constants {
        static let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        static let boarderCornerRadius: CGFloat = 23
        static let borderWidth: CGFloat = 1
        static let labelTopSpacing = 14
        static let transformScales = CGAffineTransform(scaleX: 1, y: 1)
        static let animationDuration = 0.2
        static let animationDelay: TimeInterval = 0
        static let textAttributes: [NSAttributedString.Key: Any] = [
            .font: SemiboldFont.h3,
            .foregroundColor: Assets.Colors.dark
        ]
        static let raisedTextAttributes: [NSAttributedString.Key: Any] = [
            .font: RegularFont.p4,
            .foregroundColor: Assets.Colors.grayIcon
        ]
    }
    
    //MARK: Public properties
    
    weak var customDelegate: CustomTextFieldDelegate?
    
    var placeholderText: String = "" {
        didSet {
            placeholderLabel.attributedText = NSAttributedString(
                string: placeholderText,
                attributes: Constants.textAttributes
            )
        }
    }
    
    /// Cостояние ошибки
    var isError = false {
        didSet {
            if isError {
                layer.borderColor = Assets.Colors.grayIcon.cgColor
                layer.backgroundColor = Assets.Colors.red.cgColor
            } else {
                layer.borderColor = Assets.Colors.grayIcon.cgColor
                layer.backgroundColor = Assets.Colors.background.cgColor
            }
        }
    }
    
    //MARK: Private properties
    
    private lazy var placeholderLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.attributedText = NSMutableAttributedString(
            string: titleLabel.text ?? "", attributes: Constants.textAttributes
        )
        return titleLabel
    }()

    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTextFieldDelegate {
    func textFieldShouldClear() {}
    func textFieldShouldEndEditing() {}
    func textFieldShouldReturn() {}
}

//MARK: Paddings

extension CustomTextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.padding)
    }
}

//MARK: Extension UITextFieldDelegate

extension CustomTextField: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
                
        let attributedString = NSMutableAttributedString(
            string: textField.text ?? "", attributes: Constants.textAttributes
        )
        attributedString.replaceCharacters(in: NSRange(location: range.location, length: range.length), with: string)
        textField.attributedText = attributedString
        
        layer.borderColor = attributedString.string.isEmpty
        ? Assets.Colors.grayIcon.cgColor
        : Assets.Colors.accent.cgColor
        customDelegate?.textField()
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        floatTitle()
        customDelegate?.textFieldShouldBeginEditing()
        return true
    }
    
    /// Пользователь заполняет textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performAnimation()
        customDelegate?.textFieldDidBeginEditing()
    }
    
    /// Пользователь закончил заполнять textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderColor = Assets.Colors.grayIcon.cgColor
        layer.backgroundColor = Assets.Colors.background.cgColor
                
        if textField.text?.isEmpty ?? false {
            configureEndEditing()
        }
        customDelegate?.textFieldDidEndEditing()
    }
}

//MARK: Animation

private extension CustomTextField {
    
    func performAnimation() {
        UIView.animate(
        withDuration: Constants.animationDuration,
        delay: Constants.animationDelay,
        options: .curveEaseOut,
        animations: {
            self.placeholderLabel.transform = Constants.transformScales
            self.layoutIfNeeded()
        })
    }
}

// MARK: Private methods

private extension CustomTextField {
    
    /// Создание начального вида
    func setupUI() {
        self.delegate = self
        layer.cornerRadius = Constants.boarderCornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Assets.Colors.grayIcon.cgColor
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.labelTopSpacing)
            $0.leading.equalToSuperview().offset(AppConstants.normalSpacing)
        }
    }
    
    /// Label поднимается
    func floatTitle() {
        placeholderLabel.attributedText = NSMutableAttributedString(
            string: placeholderLabel.text ?? "", attributes: Constants.raisedTextAttributes
        )
        placeholderLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(AppConstants.tinySpacing)
            $0.leading.equalToSuperview().offset(AppConstants.normalSpacing)
        }
    }
    
    /// Label опускается
    func unfloatTitle() {
        placeholder = nil
        placeholderLabel.attributedText = NSMutableAttributedString(
            string: placeholderLabel.text ?? "", attributes: Constants.textAttributes
        )
        placeholderLabel.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(Constants.labelTopSpacing)
            $0.leading.equalToSuperview().offset(AppConstants.normalSpacing)
        }
    }

    func configureEndEditing() {
        unfloatTitle()
        performAnimation()
    }
}
