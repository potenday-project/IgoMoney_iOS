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
    .background(ColorConstants.primary7)
  }
}
