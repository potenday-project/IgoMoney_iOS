//
//  Font + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

enum PretendardWeight: String {
  case extraLight = "ExtraLight"
  case light = "Light"
  case thin = "Thin"
  case regular = "Regular"
  case medium = "Medium"
  case semiBold = "SemiBold"
  case bold = "Bold"
  case extraBold = "ExtraBold"
  case black = "Black"
}

extension Font {
  static func pretendard(size: CGFloat, weight: PretendardWeight) -> Font {
    let uiFont = UIFont.pretendard(size: size, weight: weight)
    return Font(uiFont)
  }
}

extension UIFont {
  static func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
    let fontName = "Pretendard-\(weight.rawValue)"
    return UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size)
  }
}
