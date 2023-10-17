//
//  ExploreChallengeFilterSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeFilterView: View {
  let viewStore: ViewStoreOf<ExploreChallengeCore>
  
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
      FilterChallengeCategorySection(viewStore: viewStore) {
        SectionHeaderView(title: "챌린지 주제")
      }
      
      FilterTargetMoneySection(viewStore: viewStore) {
        SectionHeaderView(title: "챌린지 금액")
      }
      
      Spacer()
      
      Button("완료") {
        viewStore.send(.confirmFilter)
      }
      .font(.pretendard(size: 18, weight: .medium))
      .buttonStyle(.plain)
      .frame(maxWidth: .infinity)
      .padding()
      .background(
        viewStore.isSelectAll ? ColorConstants.primary : ColorConstants.gray3
      )
      .cornerRadius(8)
      .padding(.bottom, 32)
    }
    .padding(.horizontal, 24)
  }
}

struct FilterChallengeCategorySection<Header: View>: View {
  let viewStore: ViewStoreOf<ExploreChallengeCore>
  let header: () -> Header
  
  init(viewStore: ViewStoreOf<ExploreChallengeCore>, @ViewBuilder header: @escaping () -> Header) {
    self.viewStore = viewStore
    self.header = header
  }
  
  var body: some View {
    Section {
      header()
      
      LazyVGrid(columns: Array(repeating: .init(), count: 3)) {
        ForEach(ChallengeCategory.allCases, id: \.rawValue) { category in
          Button {
            viewStore.send(.selectCategory(category))
          } label: {
            ChallengeCategoryView(
              isSelection: category == viewStore.categorySelection,
              category: category
            )
          }
        }
      }
    }
  }
}

struct FilterTargetMoneySection<Header: View>: View {
  let viewStore: ViewStoreOf<ExploreChallengeCore>
  let header: () -> Header
  
  init(viewStore: ViewStoreOf<ExploreChallengeCore>, @ViewBuilder header: @escaping () -> Header) {
    self.viewStore = viewStore
    self.header = header
  }
  
  var body: some View {
    Section {
      header()
      
      HStack {
        ForEach(TargetMoneyAmount.allCases, id: \.description) { moneyAmount in
          Button {
            viewStore.send(.selectMoney(moneyAmount))
          } label: {
            ChallengeTargetMoneyView(
              isSelection: moneyAmount == viewStore.moneySelection,
              amount: moneyAmount
            )
          }
        }
      }
    }
  }
}

#Preview {
  ExploreChallengeFilterView(
    viewStore: ViewStore(
      Store(
        initialState: ExploreChallengeCore.State(),
        reducer: { ExploreChallengeCore() }
      ),
      observe: { $0 }
    )
  )
}
