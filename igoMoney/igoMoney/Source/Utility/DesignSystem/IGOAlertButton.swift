//
//  IGOAlertButton.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGOAlertButton: View {
  typealias Action = () -> Void
  
  private let action: Action
  private let title: Text
  let color: Color?
  
  init(title: Text, color: Color? = nil, action: @escaping Action) {
    self.title = title
    self.color = color
    self.action = action
  }
  
  var body: some View {
    Button {
      action()
    } label: {
      title
        .frame(maxWidth: 200, maxHeight: 40)
    }
    .background(color)
    .cornerRadius(8)
  }
}
