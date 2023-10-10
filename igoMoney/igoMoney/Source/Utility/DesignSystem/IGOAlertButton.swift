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
  
  init(color: Color? = nil, action: @escaping Action, title: () -> Text) {
    self.color = color
    self.action = action
    self.title = title()
  }
  
  var body: some View {
    Button {
      action()
    } label: {
      title
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
    .background(color)
    .cornerRadius(8)
  }
}

#Preview {
  HStack(spacing: 8) {
    IGOAlertButton(color: ColorConstants.primary) {
      
    } title: {
      Text("네")
        .foregroundColor(.black)
        .font(.pretendard(size: 16, weight: .medium))
    }
    
    IGOAlertButton(color: ColorConstants.primary) {
      
    } title: {
      Text("아니요")
        .foregroundColor(.black)
        .font(.pretendard(size: 16, weight: .medium))
    }
  }
  .previewLayout(.sizeThatFits)
}
