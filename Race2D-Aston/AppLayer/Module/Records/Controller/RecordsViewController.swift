//
//  RecordsViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

class RecordsViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let navigationItemTitle = "Рекорды"
        static let inputDateFormat = "yyyy-MM-dd HH:mm:ss"
        static let outputDateFormat = "MMM d"
        static let localeIdentifire = "ru_RU"
    }
    
    //MARK: Private properties
    
    private lazy var recordsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = Assets.Colors.background
        tableView.register(RecordsTableViewCell.self, forCellReuseIdentifier: RecordsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let user: User? = {
        let user = StorageService.shared.load()
        return user
    }()
    
    //MARK: Inizialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        user?.records.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordsTableViewCell.identifier, for: indexPath) as? RecordsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.isUserInteractionEnabled = false
        
        if let record = user?.records[indexPath.row] {
            let cellModel = RecordTableViewCellModel(
                userImage: user?.imageName,
                username: user?.name,
                score: record.score,
                date: formatDate(from: record.date)
            )
            cell.configure(with: cellModel)
        }
        return cell
    }
}

//MARK: Private methods

private extension RecordsViewController {
    
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.navigationItemTitle
        let textAttributes = [NSAttributedString.Key.foregroundColor: Assets.Colors.dark]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(recordsTableView)
        
        recordsTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: Constants.localeIdentifire)
        dateFormatter.timeStyle = .short
        let formattedDate = dateFormatter.string(from: date)
            
        return formattedDate
    }
}
