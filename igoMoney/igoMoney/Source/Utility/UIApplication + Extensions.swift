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
