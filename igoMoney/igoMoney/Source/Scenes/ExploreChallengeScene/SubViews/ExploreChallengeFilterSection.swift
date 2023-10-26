//
//  ExploreChallengeFilterSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeFilterView: View {
  let store: StoreOf<ExploreChallengeFilterCore>
  
  @ViewBuilder
  private func SectionHeaderView(title: String) -> some View {
    HStack {
      Text(title)
      
      Spacer()
    }
    .font(.pretendard(size: 18, weight: .bold))
  }
  
  var body: some View {
    VStack {
      FilterChallengeCategorySection(store: store) {
        SectionHeaderView(title: "챌린지 주제")
      }
      
      FilterTargetMoneySection(store: store) {
        SectionHeaderView(title: "챌린지 금액")
      }
      
      Spacer()
      
      WithViewStore(self.store, observe: { $0 }) { viewStore in
        Button("완료") {
          viewStore.send(.confirm)
        }
        .font(.pretendard(size: 18, weight: .medium))
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
          viewStore.canConfirm ? ColorConstants.primary : ColorConstants.gray5
        )
        .cornerRadius(8)
        .padding(.bottom, 32)
      }
    }
    .padding(.horizontal, 24)
  }
}

struct FilterChallengeCategorySection<Header: View>: View {
  let store: StoreOf<ExploreChallengeFilterCore>
  var header: () -> Header
  
  init(store: StoreOf<ExploreChallengeFilterCore>, @ViewBuilder header: @escaping () -> Header) {
    self.store = store
    self.header = header
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Section {
        header()
        
        LazyVGrid(columns: Array(repeating: .init(), count: 3)) {
          ForEach(ChallengeCategory.allCases, id: \.rawValue) { category in
            Button {
              viewStore.send(.selectCategory(category))
            } label: {
              ChallengeCategoryView(
                isSelection: category == viewStore.selectedCategory,
                category: category
              )
            }
          }
        }
      }
    }
  }
}

struct FilterTargetMoneySection<Header: View>: View {
  let store: StoreOf<ExploreChallengeFilterCore>
  let header: () -> Header
  
  init(store: StoreOf<ExploreChallengeFilterCore>, @ViewBuilder header: @escaping () -> Header) {
    self.store = store
    self.header = header
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Section {
        header()
        
        HStack {
          ForEach(TargetMoneyAmount.allCases, id: \.description) { moneyAmount in
            Button {
              viewStore.send(.selectMoney(moneyAmount))
            } label: {
              ChallengeTargetMoneyView(
                isSelection: moneyAmount == viewStore.selectedMoney,
                amount: moneyAmount
              )
            }
          }
        }
      }
    }
  }
}

#Preview {
  ExploreChallengeFilterView(
    store: Store(
      initialState: ExploreChallengeFilterCore.State(),
      reducer: { ExploreChallengeFilterCore() }
    )
  )
}
