//
//  IGOAuthButton.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGOAuthButton: View {
  let provider: Provider
  let action: () -> Void
  
  init(
    provider: Provider,
    action: @escaping () -> Void
  ) {
    self.provider = provider
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      HStack {
        Image(provider.iconName)
        
        Text(provider.description)
      }
      .frame(maxWidth: .infinity)
      .foregroundColor(.black)
      .padding(.vertical, 16)
      .background(Color(provider.colorName))
      .cornerRadius(8)
    }
  }
}
