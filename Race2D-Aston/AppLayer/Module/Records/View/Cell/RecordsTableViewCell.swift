//
//  RecordsTableViewCell.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 14.03.2024.
//

import UIKit
import SnapKit

final class RecordsTableViewCell: UITableViewCell {
    
    // MARK: Constants
    
    private enum Constants {
        static let userImageSize = 50.0
        static let scoreLabelText = "Счет: "
    }
    
    //MARK: Static properties
        
    static var identifier: String { "\(Self.self)" }
    
    //MARK: Private properties
    
    private lazy var rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = AppConstants.compactSpacing
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()

    private lazy var rootResultStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()

    private lazy var usernameStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()

    private lazy var resultStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var userImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = SemiboldFont.h2
        label.textColor = Assets.Colors.dark
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p1
        label.textColor = Assets.Colors.dark
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = RegularFont.p1
        label.textColor = Assets.Colors.dark
        return label
    }()
    
    //MARK: Inizialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Internal methods

extension RecordsTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
        usernameLabel.text = nil
        scoreLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with model: RecordTableViewCellModel) {
        userImageView.image = StorageService.shared.loadImage(by: (model.userImage ?? ""))
        usernameLabel.text = model.username
        scoreLabel.text = Constants.scoreLabelText + "\(model.score)"
        dateLabel.text = "\(model.date)"
    }
}

//MARK: Private methods

private extension RecordsTableViewCell {
    
    func setupUI() {
        backgroundColor = Assets.Colors.background
        configureLayout()
    }
    
    func configureLayout() {
        contentView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubview(userImageView)
        rootStackView.addArrangedSubview(rootResultStackView)
        
        rootResultStackView.addArrangedSubview(usernameStackView)
        rootResultStackView.addArrangedSubview(resultStackView)

        usernameStackView.addArrangedSubview(usernameLabel)
        resultStackView.addArrangedSubview(dateLabel)
        resultStackView.addArrangedSubview(scoreLabel)
        
        rootStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(AppConstants.normalSpacing)
        }
        
        userImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.userImageSize)
        }
    }
}
