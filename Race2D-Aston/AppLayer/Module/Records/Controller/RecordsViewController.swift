//
//  RecordsViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

class RecordsViewController: UIViewController {
    
    private lazy var recordsView: RecordsView = {
        let view = RecordsView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: Private methods

private extension RecordsViewController {
    
    func setupUI() {
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(recordsView)
        
        recordsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
           
        }
    }
}
