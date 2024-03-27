//
//  RaceView.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

//MARK: RaceViewDelegate

protocol RaceViewDelegate: AnyObject {
    func didCarHit()
}

final class RaceView: UIView {
    
    //MARK: Constants
    
    private enum Constants {
        static let lineViewWidth = 10.0
        static let lineViewHeight = 50.0
        
        static let verticalAnimationTimeInterval = 0.01
        static let horizontalAnimationTimeInterval = 0.3
        static let animationDelay: TimeInterval = 0
        
        static let obstacleCreatingDelay: ClosedRange<Double> = 0.5...1.5
        static let obstacleImageWidth = 50.0
        static let obstacleImageHeight = 50.0
        static let obstacleImageViewTag = 1
        
        static let carImageWidth = 50.0
        static let carImageHeight = 104.0
        
        static let scoreLabelHeight = 30.0
        
        static let numberOfStripes = 1 + Int(
            UIScreen.main.bounds.height / (Constants.lineViewHeight + AppConstants.normalSpacing)
        )
    }
    
    // MARK: Internal properties
    
    weak var delegate: RaceViewDelegate?
    var animationSpeed: CGFloat?
    var obstacleImageName: String?
    
    var carImageName: String? {
        didSet {
            carImageView.image = UIImage(named: carImageName ?? "")
        }
    }

    var isAnimating = true {
        didSet {
            if isAnimating {
                startAnimatingLines()
                startAnimatingObstacle()
            }
        }
    }
    
    var scoreCount = 0 {
        didSet {
            scoreLabel.text = "Счет: \(scoreCount)"
        }
    }
    
    var carIsLeft: Bool = true {
        didSet {
            carAnimation()
        }
    }
    
    // MARK: Private properties
    
    private var timer: Timer?
    private var lineViews: [UIView] = []
    
    private lazy var roadView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.zPosition = 1
        return imageView
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = SemiboldFont.h1
        label.textColor = Assets.Colors.dark
        label.textAlignment = .center
        label.layer.zPosition = 1
        return label
    }()
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Action

private extension RaceView {
    
    func didCarHit() {
        delegate?.didCarHit()
    }
}

//MARK: Internal extension

extension RaceView {
    
    func removeObstacles() {
        roadView.subviews.forEach {
            if $0.tag == Constants.obstacleImageViewTag {
                $0.removeFromSuperview()
            }
        }
    }
}

//MARK: Private extension

private extension RaceView {
    
    func setupUI() {
        backgroundColor = Assets.Colors.orange
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(roadView)
        addSubview(scoreLabel)
        roadView.addSubview(carImageView)
        
        let roadXPos = bounds.width * 0.2
        let roadYPos = frame.minY
        roadView.frame = CGRect(
            x: roadXPos,
            y: roadYPos,
            width: bounds.width - roadXPos * 2,
            height: bounds.height
        )
        
        scoreLabel.frame = CGRect(
            x: 0,
            y: AppConstants.largeSpacing,
            width: bounds.width,
            height: Constants.scoreLabelHeight
        )
        
        for _ in 0 ... Constants.numberOfStripes {
            let lineView = UIView()
            lineView.backgroundColor = Assets.Colors.white
            roadView.addSubview(lineView)
            
            let lineXPos = roadView.bounds.width * 0.5 - (Constants.lineViewWidth / 2)
            let lineYPos = -Constants.lineViewHeight + (Double((lineViews.count)) * (Constants.lineViewHeight + AppConstants.normalSpacing))
            lineView.frame = CGRect(
                x: lineXPos,
                y: lineYPos,
                width: Constants.lineViewWidth,
                height: Constants.lineViewHeight
            )
            lineViews.append(lineView)
        }
        
        let carXPos = roadView.bounds.width * 0.25 - (Constants.carImageWidth / 2)
        let carYPos = roadView.bounds.height - Constants.carImageHeight - AppConstants.largeSpacing
        carImageView.frame = CGRect(
            x: carXPos,
            y: carYPos,
            width: Constants.carImageWidth,
            height: Constants.carImageHeight
        )
    }
    
    func checkIntersection(_ firstView: UIView, _ secondView: UIView) {
        if firstView.frame.intersects(firstView.convert(secondView.frame, from: secondView)) {
            self.didCarHit()
        }
    }
    
    //MARK: Animations
    
    func startAnimatingLines() {
        lineViews.forEach {
            lineAnimation($0)
        }
    }
    
    func startAnimatingObstacle() {
        if !isAnimating {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: Constants.obstacleCreatingDelay)) {
            self.createObstacle()
            self.startAnimatingObstacle()
        }
    }
    
    func stopAnimatingLines() {
        lineViews.forEach {
            $0.layer.removeAllAnimations()
        }
    }
    
    func lineAnimation(_ lineView: UIView) {
        if !isAnimating { return }
        if lineView.frame.minY >= self.roadView.bounds.height {
            lineView.frame.origin.y = -lineView.bounds.height
        }
        
        UIView.animate(
            withDuration: Constants.verticalAnimationTimeInterval,
            delay: Constants.animationDelay,
            options: [.curveLinear],
            animations: {
                lineView.frame.origin.y += self.animationSpeed ?? CGFloat()
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.lineAnimation(lineView)
            }
        )
    }

    func createObstacle() {
        let obstacleView = UIImageView()
        obstacleView.image = UIImage(named: obstacleImageName ?? "")
        obstacleView.tag = Constants.obstacleImageViewTag
        
        let xPos = Bool.random()
        ? roadView.bounds.width * 0.25 - (Constants.obstacleImageWidth / 2)
        : roadView.bounds.width * 0.75 - (Constants.obstacleImageWidth / 2)
        
        roadView.addSubview(obstacleView)
        obstacleView.frame = CGRect(
            x: xPos,
            y: -Constants.obstacleImageHeight,
            width: Constants.obstacleImageWidth,
            height: Constants.obstacleImageHeight
        )

        obstacleAnimation(obstacleView)
    }
    
    func obstacleAnimation(_ obstacleView: UIView) {
        if !isAnimating { return }
        guard obstacleView.frame.origin.y < roadView.bounds.height else {
            obstacleView.removeFromSuperview()
            return
        }
    
        UIView.animate(
            withDuration: Constants.verticalAnimationTimeInterval,
            delay: Constants.animationDelay,
            options: .curveLinear,
            animations: {
                obstacleView.frame.origin.y += self.animationSpeed ?? CGFloat()
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                if obstacleView.superview != nil {
                    obstacleAnimation(obstacleView)
                    checkIntersection(obstacleView, carImageView)
                }
            }
        )
    }
    
    func carAnimation() {
        switch carIsLeft {
        case true:
            UIView.animate(
                withDuration: Constants.horizontalAnimationTimeInterval,
                delay: Constants.animationDelay,
                options: .curveLinear,
                animations: {
                    let xPos = self.roadView.bounds.width * 0.25
                    let yPos = self.roadView.bounds.height - Constants.carImageHeight / 2 - AppConstants.largeSpacing
                    self.carImageView.center = CGPoint(x: xPos, y: yPos)
                }
            )
        case false:
            UIView.animate(
                withDuration: Constants.horizontalAnimationTimeInterval,
                delay: Constants.animationDelay,
                options: .curveLinear,
                animations: {
                    let xPos = self.roadView.bounds.width * 0.75
                    let yPos = self.roadView.bounds.height - Constants.carImageHeight / 2 - AppConstants.largeSpacing
                    self.carImageView.center = CGPoint(x: xPos, y: yPos)
                }
            )
        }
    }
}


