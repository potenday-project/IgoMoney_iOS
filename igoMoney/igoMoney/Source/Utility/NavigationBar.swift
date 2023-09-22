//
//  NavigationBar.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGONavigationBar<C, L, R>: View where C: View, L: View, R: View {
  let leftView: (() -> L)?
  let centerView: (() -> C)?
  let rightView: (() -> R)?
  
  init(
    centerView: (() -> C)? = nil,
    leftView: (() -> L)? = nil,
    rightView: (() -> R)? = nil
  ) {
    self.leftView = leftView
    self.centerView = centerView
    self.rightView = rightView
  }
  
  var body: some View {
    ZStack {
      HStack {
        self.leftView?()
        
        Spacer()
        
        self.rightView?()
      }
      
      HStack {
        Spacer()
        
        self.centerView?()
        
        Spacer()
      }
    }
    .frame(maxWidth: .infinity)
  }
}
