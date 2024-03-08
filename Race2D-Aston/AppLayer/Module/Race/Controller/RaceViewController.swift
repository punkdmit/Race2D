//
//  RaceViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

class RaceViewController: UIViewController {
    
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

    private var raceModel = Race(
        gameSpeed: .fast,
        obstacleName: .tree,
        carColorName: .carRed,
        control: .tap
    )
    
    private lazy var raceView: RaceView = {
        let view = RaceView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.delegate = self
        return view
    }()
    
//    override func loadView() {
//        let raceView = RaceView()
//        raceView.delegate = self
//        view = raceView
//    }
    
    //MARK: Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGame()
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
    }
}

//MARK: UIGestureRecognizerDelegate

extension RaceViewController: UIGestureRecognizerDelegate {
    
    private func tapObserver() {
        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(executeTap))
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
        
        if leftArea.contains(point) {
            print("Left tapped")
            raceView.carIsLeft = true
        } else {
            print("Right tapped")
            raceView.carIsLeft = false
        }
    }
    
    private func swipeObserver() { }
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
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(raceView)
//        raceView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: Constants.alertTitle + "\(secondsCounter)",
            message: Constants.alertMessage,
            preferredStyle: .alert
        )
        ///Добавил
        alert.addAction(UIAlertAction(title: Constants.alertDefaultAction, style: .default) { _ in
            self.resetSubviews()
            self.timerStart()
            self.startAnimating()
        })
        alert.addAction(UIAlertAction(title: Constants.alertCancelAction, style: .cancel) { _ in
            ///МБ добавить обнуление всего - проверить
            self.back()
        })
        self.present(alert, animated: true, completion: nil)
    }

    func setupGame() {
        setupCar()
        setupGameSpeed()
        setupObstacle()
        setupControl()
    }
    
    func setupCar() {
        raceView.carImageName = raceModel.carColorName.rawValue
    }
    
    func setupGameSpeed() {
        raceView.animationSpeed = raceModel.gameSpeed.rawValue
    }
    
    func setupObstacle() {
        raceView.obstacleImageName = raceModel.obstacleName.rawValue
    }
    
    func setupControl() {
        switch raceModel.control {
        case .tap:
            tapObserver()
        case .swipe:
            swipeObserver()
        }
    }
    
    func startAnimating() {
//        raceView.startAnimatingLines()
//        raceView.startAnimatingObstacle()
        raceView.isAnimating = true
    }
    
    func stopAnimating() {
//        raceView.stopAnimatingLines()
        raceView.isAnimating = false
    }
    
    func resetSubviews() {
        raceView.removeObstacles()
    }
    
//    func timerBeforeGameStart() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//            self?.beforeStartTime -= 1
//        }
//
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
//            self?.timerStop()
//            self?.timerStart()
//        }
//    }
}
