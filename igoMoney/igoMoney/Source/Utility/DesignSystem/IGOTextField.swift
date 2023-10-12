//
//  TextView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved

import SwiftUI

import ComposableArchitecture

struct IGOTextField: UIViewRepresentable {
  let store: StoreOf<TextFieldCore>
  let configuration: TextFieldConfiguration
  
  func makeUIView(context: Context) -> IGOTextFieldView {
    let textField = IGOTextFieldView(
      with: ViewStore(store, observe: { $0 }),
      configuration: configuration
    )
    
    return textField
  }
  
  func updateUIView(_ uiView: IGOTextFieldView, context: Context) { }
}
