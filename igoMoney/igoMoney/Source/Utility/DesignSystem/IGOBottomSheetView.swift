//
//  IGOBottomSheetView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGOBottomSheetView<Content: View>: View {
  @Binding var isOpen: Bool
  
  let maxHeight: CGFloat
  let minHeight: CGFloat
  let content: Content
  
  @GestureState private var transition: CGFloat = .zero
  
  init(
    isOpen: Binding<Bool>,
    maxHeight: CGFloat,
    @ViewBuilder content: () -> Content
  ) {
    self._isOpen = isOpen
    self.maxHeight = maxHeight
    self.minHeight = maxHeight * 0.6
    self.content = content()
  }
  
  private var offset: CGFloat {
    return isOpen ? 0 : maxHeight - minHeight
  }
  
  private var indicator: some View {
    RoundedRectangle(cornerRadius: .infinity)
      .fill(ColorConstants.gray4)
      .frame(width: 62, height: 5)
  }
  
  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: .zero) {
        self.indicator.padding()
        self.content
      }
      .frame(width: proxy.size.width, height: self.maxHeight, alignment: .top)
      .background(Color.white)
      .cornerRadius(20)
      .frame(height: proxy.size.height, alignment: .bottom)
      .offset(y: max(self.offset, self.transition, 0))
      .animation(.interactiveSpring(), value: isOpen)
      .animation(.interactiveSpring(), value: transition)
      .gesture(
        DragGesture().updating(self.$transition) { value, state, _ in
          state = value.translation.height
        }
          .onEnded { value in
            let snapDistance = self.maxHeight * 0.5
            guard abs(value.translation.height) > snapDistance else { return }
            
            self.isOpen = value.translation.height < 0
          }
      )
    }
  }
}
