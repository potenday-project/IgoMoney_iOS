//
//  LineHeight.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct FontWithLineHeight: ViewModifier {
  let font: UIFont
  let lineHeight: CGFloat
  
  func body(content: Content) -> some View {
    content
      .font(Font(font))
      .lineSpacing(lineHeight - font.lineHeight)
      .padding(.vertical, (lineHeight - font.lineHeight) / 2)
  }
}

extension View {
  func lineHeight(font: UIFont, lineHeight: CGFloat) -> some View {
    modifier(FontWithLineHeight(font: font, lineHeight: lineHeight))
  }
}
