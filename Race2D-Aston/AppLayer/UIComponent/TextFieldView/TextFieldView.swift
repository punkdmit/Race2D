//
//  TextFieldView.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 18.02.2024.
//

import SnapKit
import UIKit

//MARK: TextFieldViewDelegate

protocol TextFieldViewDelegate: CustomTextFieldDelegate { }

//MARK: TextFieldView class

final class TextFieldView: UIView {
    
    //MARK: Constants
    
    private enum Constants {
        static let errorSpacing: CGFloat = 2
        static let textFiledHeight = 48
    }
    
    //MARK: Public perties

    var placeholderText: String = "" {
        didSet {
            customTextField.placeholderText = placeholderText
        }
    }
    
    // MARK: Private properties
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.errorSpacing
        return stackView
    }()
    
    private lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = Assets.Colors.red
        errorLabel.font = RegularFont.p3
        return errorLabel
    }()
    
    private lazy var customTextField: CustomTextField = {
        customTextField = CustomTextField()
        customTextField.customDelegate = self
        return customTextField
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

//MARK: Public extensions

extension TextFieldView {
    
    /// Метод показа ошибки
    func showError(_ errorMessage: String?) {
        errorLabel.text = errorMessage ?? ""
        errorMessageSetup(errorMessage.isEmptyOrNil)
    }
}

//MARK: CustomTextFieldDelegate

extension TextFieldView: TextFieldViewDelegate {
    
    func textFieldDidBeginEditing() {
        customTextField.isError = false
        errorLabel.isHidden = true
    }
}

//MARK: TextFieldViewDelegate extension

extension TextFieldViewDelegate {
    func textFieldDidEndEditing() { }
    func textFieldShouldBeginEditing() { }
    func textField() { }
    func textFieldShouldClear() { }
    func textFieldShouldEndEditing() { }
    func textFieldShouldReturn() { }
}

//MARK: Private extension

private extension TextFieldView {
    
    func setupUI() {
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(customTextField)
        stackView.addArrangedSubview(errorLabel)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        customTextField.snp.makeConstraints {
            $0.height.equalTo(Constants.textFiledHeight)
            $0.leading.trailing.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(AppConstants.normalSpacing)
        }
    }
    
    func errorMessageSetup(_ errorValue: Bool) {
        customTextField.isError = errorValue
        errorLabel.isHidden = !errorValue
    }
}
