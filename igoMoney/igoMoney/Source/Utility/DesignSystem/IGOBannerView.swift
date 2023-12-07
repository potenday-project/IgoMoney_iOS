//
//  IGOBannerView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct IGOBannerView<T: View, M: View, B: View>: View {
  let topView: () -> T
  let middleView: () -> M
  let bottomView: () -> B
  
  init(
    topView: @escaping () -> T = { EmptyView() },
    middleView: @escaping () -> M = { EmptyView() },
    bottomView: @escaping () -> B = { EmptyView() }
  ) {
    self.topView = topView
    self.middleView = middleView
    self.bottomView = bottomView
  }
  
  var body: some View {
    VStack(spacing: 4) {
      topView()
      
      middleView()
        .frame(maxWidth: .infinity)
      
      bottomView()
        .frame(maxWidth: .infinity)
    }
    .padding(16)
    .background(
      LinearGradient(
        gradient: Gradient(
          colors: [ColorConstants.primary6, Color(red: 253 / 255, green: 1, blue: 174 / 255)]
        ),
        startPoint: .top,
        endPoint: .bottom
      )
      .cornerRadius(10)
    )
  }
}
