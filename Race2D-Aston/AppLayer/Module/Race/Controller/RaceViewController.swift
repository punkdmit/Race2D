//
//  RaceViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

class RaceViewController: GenericViewController<RaceView> {
    
    // MARK: Constants
    
    private enum Constants { }
    
//    private var timer: Timer?
//    private var timeElapsed: TimeInterval = 0
//    private var beforeStartTime: TimeInterval = 3
    
    private var raceModel: Race?

    override func viewDidLoad() {
        super.viewDidLoad()
        createRaceModel()
        setupGame()
    }
    
    func createRaceModel() {
        raceModel = Race(
            gameSpeed: .fast,
            obstacleName: .tree,
            carColorName: .carRed
        )
    }

    func setupGame() {
        createCar()
        setupGameSpeed()
        setupObstacle()
    }
    
    func createCar() {
        guard let raceModel = raceModel else { return }
        rootView.carImageName = raceModel.carColorName.rawValue
    }
    
    func setupGameSpeed() {
        guard let raceModel = raceModel else { return }
        rootView.animationSpeed = raceModel.gameSpeed.rawValue
        rootView.isAnimating = true
    }
    
    func setupObstacle() {
        guard let raceModel = raceModel else { return }
//        rootView.obstacleImageName = raceModel.obstacleName.rawValue
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
//    
//    func timerStart() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//            self?.timeElapsed += 1
//        }
//        
//        Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { [weak self] _ in
//            self?.timerStop()
//        }
//    }
//    
//    func timerStop() {
//        timer?.invalidate()
//        timer = nil
//    }

}
