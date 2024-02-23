//
//  GenericViewController.swift
//  Race2D-Aston
//
//  Created by Dmitry Apenko on 22.02.2024.
//

import UIKit

class GenericViewController<T: UIView>: UIViewController {
    public var rootView: T { return view as! T }
        
      override open func loadView() {
         self.view = T()
      }
}
