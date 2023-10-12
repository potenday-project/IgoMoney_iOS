//
//  View + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

extension View {
  func textEditorBackground<Content: View>(_ content: @escaping () -> Content) -> some View {
    if #available(iOS 16.0, *) {
      return self.scrollContentBackground(.hidden)
        .background(content())
    } else {
      UITextView.appearance().backgroundColor = .clear
      return self.background(content())
    }
  }
}
