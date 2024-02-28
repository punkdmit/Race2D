//
//  RaceView.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit
import SnapKit

class RaceView: UIView {
    
    //MARK: Constants

    private enum Constants {
        static let roadViewWidth = 0.6
        static let lineViewWidth = 10.0
        static let lineViewHeight = 50.0
        static let lineViewsSpacing = 15.0
        static let animationTimeInterval = 0.01
        static let animationDelay: TimeInterval = 0
    }
    
    // MARK: Private properties

    private var timer: Timer?
        
    // MARK: Public properties
    
    public var animationSpeed: CGFloat?

    public var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
    
    public var carImageName: String = "" {
        didSet {
            carImageView.image = UIImage(named: carImageName)
        }
    }
    
//    public var obstacleImageName: String = "" {
//        didSet {
//            obstacleImageView.image = UIImage(named: obstacleImageName)
//        }
//    }
    
    // MARK: Internal properties
    
    var lineViews: [UIView] = []
    
    lazy var roadView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var carImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
//    lazy var obstacleImageView: UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Pubic extension

extension RaceView {
    func startAnimating() {
        /*
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.animationTimeInterval,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }
            self.startAnimatingLines()
        }
        */
        
        startAnimatingLines()
        startAnimatingObstacle()
    }
    
    func startAnimatingLines() {
        lineViews.forEach {
            animateLine($0)
        }
    }

    func animateLine(_ lineView: UIView) {
        var newFrame = lineView.frame
        if newFrame.origin.y >= self.roadView.bounds.height {
            newFrame.origin.y = -newFrame.height
            lineView.frame = newFrame
        }
        UIView.animate(
            withDuration: Constants.animationTimeInterval,
            delay: Constants.animationDelay,
            options: [.curveLinear],
            animations: {
                newFrame.origin.y += self.animationSpeed ?? CGFloat()
                lineView.frame = newFrame
            },
            completion: { [weak self] _ in
                self?.animateLine(lineView)
            }
        )
    }
    
    func startAnimatingObstacle() {
        let obstacleAnimationInterval = Double.random(in: 1...3)
        timer = Timer.scheduledTimer(
            withTimeInterval: obstacleAnimationInterval,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }
            
//            let obstacleView = UIImageView()
            lazy var obstacleView: UIImageView = {
                let imageView = UIImageView()
                imageView.image = UIImage(named: "tree")
                return imageView
            }()
            
            let isLeft = Bool.random()
            let xPos = isLeft ? self.roadView.bounds.width * 0.25 : self.roadView.bounds.width * 0.75
            self.roadView.addSubview(obstacleView)
            obstacleView.snp.makeConstraints {
                $0.centerX.equalTo(self.roadView.snp.left).offset(xPos)
                $0.size.equalTo(CGSize(width: 50, height: 50))
                $0.top.equalToSuperview().offset(-50)
            }
            self.animateObstacle(obstacleView)
        }
    }
    
    func animateObstacle(_ obstacleView: UIView) {
        var newFrame = obstacleView.frame
        UIView.animate(
            withDuration: Constants.animationTimeInterval,
            delay: Constants.animationDelay,
            options: [.curveLinear],
            animations: {
                newFrame.origin.y += self.animationSpeed ?? CGFloat()
                obstacleView.frame = newFrame
            },
            completion: { [weak self] _ in
                if newFrame.origin.y >= self!.roadView.bounds.height {
                    obstacleView.removeFromSuperview()
                } else {
                    self?.animateObstacle(obstacleView)
                }
            }
        )
    }
    
//    func startAnimatingObstacle() {
//        let obstacleAnimationInterval = Double.random(in: 1...3)
//        timer = Timer.scheduledTimer(
//            withTimeInterval: obstacleAnimationInterval,
//            repeats: true
//        ) { [weak self] _ in
//            guard let self = self else { return }
//            self.animateObstacle(obstacleImageView)
//        }
//    }
//
//    func animateObstacle(_ obstacleView: UIImageView) {
//        var newFrame = obstacleView.frame
//        if newFrame.origin.y >= self.roadView.bounds.height {
////            newFrame.origin.y = -newFrame.height
////            obstacleView.frame = newFrame
//            obstacleView.removeFromSuperview()
//        }
//        UIView.animate(
//            withDuration: Constants.animationTimeInterval,
//            delay: Constants.animationDelay,
//            options: [.curveLinear],
//            animations: {
//                newFrame.origin.y += self.animationSpeed ?? CGFloat()
//                obstacleView.frame = newFrame
//            },
//            completion: { [weak self] _ in
//                self?.animateObstacle(obstacleView)
//            }
//        )
//    }
    
    func stopAnimating() {
        lineViews.forEach {
            $0.layer.removeAllAnimations()
        }
        /*
        timer?.invalidate()
        timer = nil
         */
    }
}

//MARK: Private extension

private extension RaceView {
    
    func setupUI() {
        backgroundColor = .orange
        configureLayout()
    }
    
    func configureLayout() {
        let screenHeight = UIScreen.main.bounds.height
        
        addSubview(roadView)
        roadView.addSubview(carImageView)
//        roadView.addSubview(obstacleImageView)
        
        roadView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(Constants.roadViewWidth)
        }
        
        let numberOfStripes = Int(screenHeight / (Constants.lineViewHeight + Constants.lineViewsSpacing))
        for _ in 0 ... numberOfStripes + 1 {
            let lineView: UIView = {
                let view = UIView()
                view.backgroundColor = Assets.Colors.white
                return view
            }()
            roadView.addSubview(lineView)
            lineView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(Constants.lineViewWidth)
                $0.height.equalTo(Constants.lineViewHeight)
                if let previousLineView = lineViews.last {
                    $0.top.equalTo(previousLineView.snp.bottom).offset(Constants.lineViewsSpacing)
                } else {
                    $0.top.equalToSuperview().offset(-Constants.lineViewHeight)
                }
            }
            lineViews.append(lineView)
        }
        
        carImageView.snp.makeConstraints {
//            $0.width.equalTo(carImageView.snp.height).multipliedBy(1.156)
            $0.width.equalTo(50)
            $0.height.equalTo(104)
            $0.bottom.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview().multipliedBy(0.5)
        }
    }
}


