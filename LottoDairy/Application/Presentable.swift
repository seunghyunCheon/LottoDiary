//
//  Presentable.swift
//  LottoDairy
//
//  Created by Brody on 2023/06/30.
//

import UIKit

protocol Presentable {
  func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
  
  func toPresent() -> UIViewController? {
    return self
  }
}
