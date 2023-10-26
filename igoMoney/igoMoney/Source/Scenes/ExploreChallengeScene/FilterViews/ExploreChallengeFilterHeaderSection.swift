//
//  ExploreChallengeFilterHeaderSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeFilterHeaderSection: View {
  let store: StoreOf<ExploreChallengeFilterCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack(spacing: 8) {
        Toggle(
          "전체",
          isOn: viewStore.binding(
            get: \.isSelectedAll,
            send: ExploreChallengeFilterCore.Action.selectAll
          )
        )
        .toggleStyle(IGOMenuButtonStyle(isMenu: false))
        
        Toggle(
          isOn: viewStore.binding(
            get: { $0.selectedCategory != nil },
            send: {
              let category = $0 ? ChallengeCategory.food : nil
              return .selectCategory(category)
            }
          )
        ) {
          if let selectedCategory = viewStore.selectedCategory {
            Text(selectedCategory.description)
          } else {
            Text("챌린지 주제")
          }
        }
        .toggleStyle(IGOMenuButtonStyle(isMenu: true))
        
        Toggle(
          isOn: viewStore.binding(
            get: { $0.selectedMoney != nil },
            send: {
              let money = $0 ? TargetMoneyAmount.allCases.first : nil
              return .selectMoney(money)
            }
          )
        ) {
          if let selectedMoney = viewStore.selectedMoney {
            Text(selectedMoney.description)
          } else {
            Text("금액")
          }
        }
        .toggleStyle(IGOMenuButtonStyle(isMenu: true))
        
        Spacer()
      }
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  ExploreChallengeFilterHeaderSection(
    store: Store(
      initialState: ExploreChallengeFilterCore.State(),
      reducer: { ExploreChallengeFilterCore() }
    )
  )
}
