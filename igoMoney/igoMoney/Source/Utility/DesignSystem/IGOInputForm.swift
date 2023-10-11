//
//  IGOInputForm.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGOInputForm<TitleView: View, SubTitleView: View, Content: View>: View {
  private var titleView: (() -> TitleView?)?
  private var subTitleView: (() -> SubTitleView)?
  private var content: (() -> Content)?
  
  init(
    titleView: (() -> TitleView)? = { EmptyView() },
    subTitleView: (() -> SubTitleView)? = { EmptyView() },
    content: (() -> Content)? = { EmptyView() }
  ) {
    self.titleView = titleView
    self.subTitleView = subTitleView
    self.content = content
  }
  
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        if let titleView = titleView {
          titleView()
        }
        
        
        Spacer()
        
        if let subTitleView = subTitleView {
          subTitleView()
        }
      }
      
      if let content = content {
        content()
      }
    }
  }
}
