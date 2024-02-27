//
//  RaceView.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit
import SnapKit

class RaceView: UIView {
    
    private enum Constants {
        static let roadViewWidth = 0.6
        static let lineViewWidth = 10.0
        static let lineViewHeight = 50.0
        static let lineViewsSpacing = 15.0
//        static let animationTimeInterval = 0.01
//        static let animationDelay: TimeInterval = 0
    }
    
    lazy var roadView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
//    private var timer: Timer?
    
    var lineViews: [UIView] = []
    
    public var isAnimating: Bool = false {
        didSet {
//            if isAnimating {
//                startAnimatingLines2()
//            } else {
//                stopAnimatingLines()
//            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
            $0.width.equalToSuperview().multipliedBy(Constants.roadViewWidth)
        }
        
        let screenHeight = UIScreen.main.bounds.height
        let numberOfStripes = Int(screenHeight / (Constants.lineViewHeight + Constants.lineViewsSpacing))
        for _ in 0 ... numberOfStripes + 1 {
            var lineView: UIView = {
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
    }
    
//    func startAnimatingLines() {
//        timer = Timer.scheduledTimer(
//            withTimeInterval: Constants.animationTimeInterval,
//            repeats: true
//        ) { [weak self] _ in
//            guard let self = self else { return }
//            for lineView in lineViews {
//                var newFrame = lineView.frame
//                newFrame.origin.y += 1
//                if newFrame.minY > roadView.bounds.height {
//                    newFrame.origin.y = -newFrame.height
//                }
//                lineView.frame = newFrame
//            }
//        }
//    }
    
//    func startAnimatingLines2() {
//        timer = Timer.scheduledTimer(
//            withTimeInterval: Constants.animationTimeInterval,
//            repeats: true
//        ) { [weak self] _ in
//            guard let self = self else { return }
//            for lineView in self.lineViews {
//                var newFrame = lineView.frame
//                UIView.animate(
//                    withDuration: Constants.animationTimeInterval,
//                    delay: Constants.animationDelay,
//                    options: [.curveLinear, .repeat],
//                    animations: {
////                            var newFrame = lineView.frame
//                        newFrame.origin.y += 4
//                        lineView.frame = newFrame
//                    }, completion: { _ in
//                        if lineView.frame.minY >= self.roadView.bounds.height {
////                                var newFrame = lineView.frame
//                            newFrame.origin.y = -newFrame.height
//                            lineView.frame = newFrame
//                        }
//                })
//            }
//        }
//    }
//    
//    func stopAnimatingLines() {
//        timer?.invalidate()
//        timer = nil
//    }
}


