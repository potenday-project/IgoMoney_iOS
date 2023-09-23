//
//  Font + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

extension Font {
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
  
  static func pretendard(size: CGFloat, weight: PretendardWeight) -> Font {
    let fontName = "Pretendard-\(weight.rawValue)"
    return custom(fontName, size: size)
  }
}
