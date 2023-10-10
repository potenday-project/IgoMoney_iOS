//
//  IGOAlertView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGOAlertView<Content: View>: View {
  let content: Content
  let primaryButton: IGOAlertButton
  let cancelButton: IGOAlertButton?
  
  init(
    content: () -> Content,
    primaryButton: () -> IGOAlertButton,
    secondaryButton: (() -> IGOAlertButton)? = nil
  ) {
    self.content = content()
    self.primaryButton = primaryButton()
    self.cancelButton = secondaryButton?()
  }
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.4).ignoresSafeArea()
      
      VStack(spacing: 24) {
        content
        
        HStack(spacing: 8) {
          if let secondaryButton = cancelButton {
            secondaryButton
          }
          
          primaryButton
        }
      }
      .padding(24)
      .background(Color.white)
      .cornerRadius(8)
      .padding(.horizontal, 60)
      .padding(.vertical, 10)
    }
  }
}

extension View {
  func alert<Content: View>(isPresent: Binding<Bool>, alert: () -> IGOAlertView<Content>) -> some View {
    let keyWindow = UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .compactMap { $0 as? UIWindowScene }
      .first?
      .windows
      .filter { $0.isKeyWindow }
      .first
    
    let viewController = UIHostingController(rootView: alert())
    viewController.modalTransitionStyle = .crossDissolve
    viewController.modalPresentationStyle = .overCurrentContext
    viewController.view.backgroundColor = .clear
    viewController.definesPresentationContext = true
    
    return self.onChange(of: isPresent.wrappedValue) {
      if $0 {
        keyWindow?.topViewController?.present(viewController, animated: true)
      } else {
        keyWindow?.topViewController?.dismiss(animated: true)
      }
    }
  }
}
