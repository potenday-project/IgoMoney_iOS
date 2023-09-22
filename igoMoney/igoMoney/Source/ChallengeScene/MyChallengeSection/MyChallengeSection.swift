//
//  MyChallengeSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyChallengeSection: View {
  let store: StoreOf<MyChallengeSectionCore>
  // TODO: - 섹션 reducer 연결하기
  var body: some View {
    ChallengeSectionTitleView(
      sectionType: .myChallenge,
      buttonAction: nil
    )
    
    WithViewStore(store, observe: { $0 }) { viewStore in
      // TODO: - 상태에 따른 화면 구현
      RoundedRectangle(cornerRadius: 8)
        .fill(viewStore.color)
        .frame(height: 100)
        .onTapGesture {
          let randomColor = Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
          )
          viewStore.send(.changeColor(randomColor))
        }
    }
  }
}
