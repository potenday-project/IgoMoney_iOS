//
//  IGOTextField.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGOTextField: View {
  @Binding var text: String
  let placeholder: String
  let placeholderColor: Color
  
  var body: some View {
    TextField("", text: $text)
      .background(
        HStack {
          if text.isEmpty {
            Text(placeholder)
              .foregroundColor(placeholderColor)
            
            Spacer()
          }
        }
      )
  }
}
