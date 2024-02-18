//
//  UIViewController+transitionHandler.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 18.02.2024.
//

import UIKit

protocol TransitionHandler: AnyObject {
    
    func push(_ viewController: UIViewController)
    
    func back()
}

extension UIViewController: TransitionHandler {
    
    func push(_ viewController: UIViewController) {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
