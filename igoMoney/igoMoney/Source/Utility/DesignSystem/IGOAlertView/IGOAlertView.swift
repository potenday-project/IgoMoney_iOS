//
//  IGOAlertView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct AlertViewModifier<AlertContent: View>: ViewModifier {
  var viewStore: ViewStoreOf<IGOAlertCore>
  let alertContent: () -> AlertContent
  
  init(
    viewStore: ViewStoreOf<IGOAlertCore>,
    @ViewBuilder alertContent: @escaping () -> AlertContent
  ) {
    self.viewStore = viewStore
    self.alertContent = alertContent
  }
  
  func body(content: Content) -> some View {
    ZStack {
      content
        .allowsHitTesting(viewStore.contentAllowsHitTesting)
      
      Color.black
        .opacity(viewStore.scrimOpacity)
        .opacity(viewStore.endScripOpacity)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
          viewStore.send(.scrimTapped)
        }
      
      alertContent()
        .offset(viewStore.modalOffset)
        .opacity(viewStore.modalOpacity)
    }
  }
}

extension View {
  @ViewBuilder
  func igoAlert(
    _ store: StoreOf<IGOAlertCore>,
    content: @escaping () -> some View
  ) -> some View {
    self
      .modifier(
        AlertViewModifier(
          viewStore: ViewStore(store, observe: { $0 }),
          alertContent: content
        )
      )
  }
}
