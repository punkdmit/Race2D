//
//  RaceViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

final class RaceViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let timerTimeInterval: TimeInterval = 1
        static let alertTitle = "Ваш счет: "
        static let alertMessage = "Хотите продолжить?"
        static let alertDefaultAction = "Играть"
        static let alertCancelAction = "Назад"
    }
    
    //MARK: Private properties
    
    private var timer: Timer?
    
    private var secondsCounter = 0 {
        didSet {
            raceView.scoreCount = secondsCounter
        }
    }
    
    private let user: User? = {
        let user = StorageService.shared.load()
        return user
    }()
    
    private lazy var raceView: RaceView = {
        let view = RaceView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: view.frame.height
            )
        )
        view.delegate = self
        return view
    }()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerStart()
        startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetSubviews()
    }
}

//MARK: RaceViewDelegate

extension RaceViewController: RaceViewDelegate {
    
    func didCarHit() {
        stopAnimating()
        timerStop()
        showAlert()
        addRecord()
    }
}

//MARK: UIGestureRecognizerDelegate

extension RaceViewController: UIGestureRecognizerDelegate {
    
    private func swipeObserver() {
        let swipeRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(executeSwipe)
        )
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(
            target: self,
            action: #selector(executeSwipe)
        )
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func executeSwipe(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                raceView.carIsLeft = false
            case .left:
                raceView.carIsLeft = true
            default:
                break
            }
        }
    }
    
    private func tapObserver() {
        let tapGestureRecongnizer = UITapGestureRecognizer(
            target: self,
            action: #selector(executeTap)
        )
        tapGestureRecongnizer.delegate = self
        view.addGestureRecognizer(tapGestureRecongnizer)
    }
    
    @objc func executeTap(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self.view)
        let leftArea = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width / 2,
            height: view.bounds.height
        )
        
        switch leftArea.contains(point) {
        case true:
            raceView.carIsLeft = true
        case false:
            raceView.carIsLeft = false
        }
    }
}

// MARK: Timer

private extension RaceViewController {
    
    func timerStart() {
        secondsCounter = 0
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.timerTimeInterval,
            repeats: true
        ){ [weak self] _ in
            self?.secondsCounter += 1
        }
    }
    
    func timerStop() {
        timer?.invalidate()
        timer = nil
    }
}

//MARK: Private methods

private extension RaceViewController {
    
    func setupUI() {
        navigationItem.hidesBackButton = true
        configureLayout()
        setupGame()
    }
    
    func configureLayout() {
        view.addSubview(raceView)
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: Constants.alertTitle + "\(secondsCounter)",
            message: Constants.alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: Constants.alertDefaultAction,
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.resetSubviews()
            self.resetCarPosition()
            self.timerStart()
            self.startAnimating()
        })
        alert.addAction(UIAlertAction(
            title: Constants.alertCancelAction,
            style: .cancel
        ) { [weak self] _ in
            guard let self = self else { return }
            self.back()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Game setup
    
    func setupGame() {
        setupCar()
        setupGameSpeed()
        setupObstacle()
        setupControl()
    }
    
    func setupCar() {
        guard let user = user else { return }
        raceView.carImageName = user.raceSettings.carColorName.rawValue
    }
    
    func setupGameSpeed() {
        guard let user = user else { return }
        raceView.animationSpeed = user.raceSettings.gameSpeed.rawValue
    }
    
    func setupObstacle() {
        guard let user = user else { return }
        raceView.obstacleImageName = user.raceSettings.obstacleName.rawValue
    }
    
    func setupControl() {
        guard let user = user else { return }
        switch user.raceSettings.control {
        case .tap:
            tapObserver()
        case .swipe:
            swipeObserver()
        }
    }
    
    func addRecord() {
        guard let user = user else { return }
        if user.records.count > 15 {
            user.records.removeLast()
        }
        let newUser = User(
            name: user.name,
            photo: user.imageName,
            race: user.raceSettings,
            records: user.records
        )
        newUser.records.append(Record(score: secondsCounter, date: Date()))
        StorageService.shared.save(newUser)
    }
    
    //MARK: Animations
    
    func startAnimating() {
        raceView.isAnimating = true
    }
    
    func stopAnimating() {
        raceView.isAnimating = false
    }
    
    func resetCarPosition() {
        raceView.carIsLeft = true
    }
    
    func resetSubviews() {
        raceView.removeObstacles()
    }
}
