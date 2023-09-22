//
//  UIApplication + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

extension UIApplication {
  func topWindow() -> UIWindow? {
    var keyWindow: UIWindow? = nil
    
    if #available(iOS 13.0, *) {
      for scene in connectedScenes {
        if let windowScene = scene as? UIWindowScene {
          for window in windowScene.windows {
            if window.isKeyWindow {
              keyWindow = window
            }
          }
        }
      }
    } else {
      keyWindow = self.keyWindow
    }
    
    return keyWindow
  }
}

extension UIWindow {
  public var topViewController: UIViewController? {
    return self.topViewController(vc: self.rootViewController)
  }
  
  public func topViewController(vc: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nc = vc as? UINavigationController {
      return self.topViewController(vc: nc.topViewController)
    } else if let tc = vc as? UITabBarController {
      return self.topViewController(vc: tc.selectedViewController)
    } else {
      if let pvc = vc?.presentedViewController {
        return self.topViewController(vc: pvc)
      } else {
        return vc
      }
    }
  }
}
