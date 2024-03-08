//
//  RaceView.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit
import SnapKit

protocol RaceViewDelegate: AnyObject {
    func didCarHit()
}

final class RaceView: UIView {
    
    //MARK: Constants
    
    private enum Constants {
        static let roadViewWidth = 0.6
        static let lineViewWidth = 10.0
        static let lineViewHeight = 50.0
        static let lineViewsSpacing = 15.0
        static let verticalAnimationTimeInterval = 0.01
        static let horizontalAnimationTimeInterval = 0.5
        static let animationDelay: TimeInterval = 0
        static let obstacleCreatingDelay: ClosedRange<Double> = 1...3
        static let obstacleImageWidth = 50.0
        static let obstacleImageHeight = 50.0
        static let obstacleImageViewTag = 1
        static let carImageSize = CGSize(width: 50, height: 104)
        static let carImageWidth = 50.0
        static let carImageHeight = 104.0
        static let carLeftCenterEqualToSuperview = 0.5
        static let carRightCenterEqualToSuperview = 1.5
        static let numberOfStripes = 1 + Int(
            UIScreen.main.bounds.height / (Constants.lineViewHeight + Constants.lineViewsSpacing)
        )
    }
    
    // MARK: Internal properties
    
    weak var delegate: RaceViewDelegate?
    var animationSpeed: CGFloat?
    var obstacleImageName: String?
    
    var isAnimating = true {
        didSet {
            if isAnimating {
                startAnimatingLines()
                startAnimatingObstacle()
            }
        }
    }
    
    var carImageName = "" {
        didSet {
            carImageView.image = UIImage(named: carImageName)
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
    
    var count = 0

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
        return imageView
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = SemiboldFont.h1
        label.textColor = Assets.Colors.dark
        label.text = "Счет: \(count)"
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
    
    func startAnimatingLines() {
        lineViews.forEach {
            animateLine($0)
        }
    }
    
    func startAnimatingObstacle() {
        if !isAnimating {
            print("Перестал создавать препятствия")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: Constants.obstacleCreatingDelay)) {
            self.createObstacle()
            self.startAnimatingObstacle()
        }
    }
    
    func removeObstacles() {
        roadView.subviews.forEach {
            if $0.tag == Constants.obstacleImageViewTag {
                $0.removeFromSuperview()
            }
        }
    }
    
    func stopAnimatingLines() {
        lineViews.forEach {
            $0.layer.removeAllAnimations()
        }
    }
}

//MARK: Private extension

private extension RaceView {
    
    func setupUI() {
        backgroundColor = .orange
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(roadView)
        addSubview(scoreLabel)
        roadView.insertSubview(carImageView, at: roadView.subviews.count)
        
        let roadXPos = self.bounds.width * 0.20
        let roadYPos = self.frame.minY
        roadView.frame = CGRect(
            x: roadXPos,
            y: roadYPos,
            width: bounds.width - roadXPos * 2,
            height: bounds.height
        )
//        roadView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.top.bottom.equalToSuperview()
//            $0.width.equalToSuperview().multipliedBy(Constants.roadViewWidth)
//        }
        
        scoreLabel.frame = CGRect(x: 0, y: 15, width: roadView.frame.size.width, height: 20)

//        scoreLabel.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide)
//            $0.centerX.equalToSuperview()
//        }
        for _ in 0 ... Constants.numberOfStripes {
            let lineView = UIView()
            lineView.backgroundColor = Assets.Colors.white
            roadView.addSubview(lineView)
            
            // Пробный
            let lineXPos = roadView.bounds.width * 0.5 - (Constants.lineViewWidth / 2)
            let lineYPos = -Constants.lineViewHeight + (Double((lineViews.count)) * (Constants.lineViewHeight + Constants.lineViewsSpacing))
            lineView.frame = CGRect(
                x: lineXPos,
                y: lineYPos,
                width: Constants.lineViewWidth,
                height: Constants.lineViewHeight
            )
            
//            lineView.snp.makeConstraints {
//                $0.centerX.equalToSuperview()
//                $0.width.equalTo(Constants.lineViewWidth)
//                $0.height.equalTo(Constants.lineViewHeight)
//                if lineViews.isEmpty {
//                    $0.top.equalToSuperview()
//                        .offset(-Constants.lineViewHeight)
//                } else {
//                    $0.top.equalTo(lineViews[lineViews.count - 1].snp.bottom)
//                        .offset(Constants.lineViewsSpacing)
//                }
//            }
            
            lineViews.append(lineView)
        }
        
        // Пробный
        let carXPos = roadView.bounds.width * 0.25 - (Constants.carImageWidth / 2)
        let carYPos = roadView.bounds.height - Constants.carImageHeight - AppConstants.largeSpacing
        carImageView.frame = CGRect(
            x: carXPos,
            y: carYPos,
            width: Constants.carImageWidth,
            height: Constants.carImageHeight
        )
        carImageView.layer.zPosition = 1
        
//        carImageView.snp.makeConstraints {
//            $0.size.equalTo(Constants.carImageSize)
//            $0.bottom.equalToSuperview().inset(AppConstants.largeSpacing)
//            $0.centerX.equalToSuperview().offset(roadView.bounds.width/2)
//        }
    }
    
    func checkIntersection(_ firstView: UIView, _ secondView: UIView) {
        if firstView.frame.intersects(firstView.convert(secondView.frame, from: secondView)) {
            self.didCarHit()
        }
    }
    
    //MARK: Animations
    
    func animateLine(_ lineView: UIView) {
        if !isAnimating { return }
        
        if lineView.frame.minY >= self.roadView.bounds.height {
            lineView.frame.origin.y = -lineView.frame.height
            count += 1
            print("перенесен \(count)")
        }
        
        UIView.animate(
            withDuration: Constants.verticalAnimationTimeInterval,
            delay: Constants.animationDelay,
            options: [.curveLinear],
            animations: {
                lineView.frame.origin.y += self.animationSpeed ?? CGFloat()
            },
            completion: { [weak self] _ in
                self?.animateLine(lineView)
            }
        )
    }

    func createObstacle() {
        print("Создал препятствие")
        
        let obstacleView = UIImageView()
        obstacleView.image = UIImage(named: obstacleImageName ?? String())
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


