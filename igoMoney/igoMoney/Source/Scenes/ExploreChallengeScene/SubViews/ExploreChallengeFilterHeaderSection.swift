//
//  ExploreChallengeFilterHeaderSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeFilterCore: Reducer {
  struct State: Equatable {
    var selectedCategory: ChallengeCategory?
    var selectedMoney: TargetMoneyAmount?
    var isSelectedAll: Bool = true
    
    var canConfirm: Bool {
      return selectedCategory != nil || selectedMoney != nil
    }
  }
  
  enum Action: Equatable {
    case selectCategory(ChallengeCategory?)
    case selectMoney(TargetMoneyAmount?)
    case selectAll(Bool)
    case confirm
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .selectCategory(.some(let category)):
      if state.selectedCategory == category {
        state.selectedCategory = nil
        return .none
      }
      
      state.selectedCategory = category
      return .send(.selectAll(false))
      
    case .selectCategory(.none):
      return .send(.selectAll(true))
      
    case .selectMoney(.some(let moneyAmount)):
      if state.selectedMoney == moneyAmount {
        state.selectedMoney = nil
        return .none
      }
      
      state.selectedMoney = moneyAmount
      return .send(.selectAll(false))
      
    case .selectMoney(.none):
      return .send(.selectAll(true))
      
    case .selectAll(true):
      state.selectedCategory = nil
      state.selectedMoney = nil
      state.isSelectedAll = true
      return .none
      
    case .selectAll(false):
      if state.isSelectedAll == true {
        if state.selectedCategory != nil || state.selectedMoney != nil {
          state.isSelectedAll = false
          return .none
        }
        
        return .none
      }
      return .none
      
    case .confirm:
      return .none
    }
  }
}

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
