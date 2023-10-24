//
//  UIImage + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

extension UIImage {
  func resize(to width: CGFloat) -> UIImage {
    let scale = width / self.size.width
    let newHeight = size.height * scale
    
    let size = CGSize(width: width, height: newHeight)
    
    let renderer = UIGraphicsImageRenderer(size: size)
    
    let renderImage = renderer.image { context in
      self.draw(in: CGRect(origin: .zero, size: size))
    }
    print(#fileID, #function, #line, "newImage Data ", renderImage.pngData())
    return renderImage
  }
}
