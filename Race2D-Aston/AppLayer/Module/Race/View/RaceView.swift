//
//  RaceView.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

class RaceView: UIView {
    
    lazy var roadView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .orange
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(roadView)

        roadView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
        }

    }

}
