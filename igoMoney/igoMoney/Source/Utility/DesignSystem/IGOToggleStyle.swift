//
//  IGOToggleStyle.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGOToggleStyle: ToggleStyle {
  private let minWidth: CGFloat = 50
  
  func makeBody(configuration: Configuration) -> some View {
    ZStack(alignment: configuration.isOn ? .trailing : .leading) {
      RoundedRectangle(cornerRadius: .infinity)
        .stroke(
          configuration.isOn ? ColorConstants.primary3 : ColorConstants.gray4,
          lineWidth: 3
        )
        .frame(maxWidth: minWidth, maxHeight: minWidth / 2)
        .overlay(
          RoundedRectangle(cornerRadius: .infinity)
            .fill(configuration.isOn ? ColorConstants.primary8 : Color.white)
        )
      
      Circle()
        .fill(configuration.isOn ? ColorConstants.primary3 : ColorConstants.gray4)
        .frame(maxWidth: minWidth / 2, maxHeight: minWidth / 2)
        .padding(.vertical, 3)
        .padding(.horizontal, 1)
    }
    .frame(maxWidth: minWidth, maxHeight: minWidth / 2)
    .padding(2)
    .onTapGesture {
      withAnimation(.bouncy) {
        configuration.$isOn.wrappedValue.toggle()
      }
    }
  }
}

struct IGOMenuButtonStyle: ToggleStyle {
  let isMenu: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    Button {
      withAnimation {
        configuration.isOn.toggle()
      }
    } label: {
      HStack {
        configuration.label
        
        if isMenu {
          Image(systemName: "chevron.down")
        }
      }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 4)
        .stroke(configuration.isOn ? ColorConstants.primary : ColorConstants.gray5)
    )
    .foregroundColor(configuration.isOn ? .black : ColorConstants.gray2)
    .buttonStyle(.plain)
  }
}
