//
//  RaceViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

class RaceViewController: GenericViewController<RaceView> {
    
    // MARK: Constants
    
    private enum Constants {
        static let animationTimeInterval = 0.01
        static let animationDelay: TimeInterval = 0
    }
    
    private var timer: Timer?
    
    private var raceModel: Race?

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimatingLines2()
    }
    
    func createRace() {
        raceModel = Race(gameSpeed: .slow, obstacle: .tree, carColor: .carBlack)
    }
    
    func startAnimatingLines2() {
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.animationTimeInterval,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }
            for lineView in rootView.lineViews {
                var newFrame = lineView.frame
                UIView.animate(
                    withDuration: Constants.animationTimeInterval,
                    delay: Constants.animationDelay,
                    options: [.curveLinear, .repeat],
                    animations: {
//                        var newFrame = lineView.frame
                        newFrame.origin.y += 4
                        lineView.frame = newFrame
                    }, completion: { _ in
                        if lineView.frame.minY >= self.rootView.roadView.bounds.height {
//                            var newFrame = lineView.frame
                            newFrame.origin.y = -newFrame.height
                            lineView.frame = newFrame
                        }
                })
            }
        }
    }
    
    func stopAnimatingLines() {
        timer?.invalidate()
        timer = nil
    }

}
