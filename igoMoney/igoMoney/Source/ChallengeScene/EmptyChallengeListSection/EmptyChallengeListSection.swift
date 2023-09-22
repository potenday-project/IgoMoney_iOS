//
//  EmptyChallengeListSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct EmptyChallengeListSection: View {
  let store: StoreOf<EmptyChallengeListSectionCore>
  
  private func generateGridItem(count: Int, spacing: CGFloat) -> [GridItem] {
    let gridItem = GridItem(.flexible(), spacing: spacing)
    return Array(repeating: gridItem, count: count)
  }
  
  var body: some View {
    VStack(spacing: 16) {
      ChallengeSectionTitleView(sectionType: .emptyChallenge) {
        store.send(.showExplore(true))
      }
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        NavigationLink(
          isActive: viewStore.binding(
            get: \.showExplore,
            send: EmptyChallengeListSectionCore.Action.showExplore
          )
        ) {
          IfLetStore(
            store.scope(
              state: \.exploreChallengeState,
              action: EmptyChallengeListSectionCore.Action.exploreChallengeAction
            )
          ) { store in
            ExploreChallengeScene(store: store)
          }
        } label: {
          EmptyView()
        }
      }
      
      LazyVGrid(columns: generateGridItem(count: 2, spacing: 16), spacing: 12) {
        ForEachStore(store.scope(
          state: \.challenges,
          action: EmptyChallengeListSectionCore.Action.challengeDetail)
        ) { store in
          EmptyChallengeDetail(store: store)
        }
      }
    }
    .onAppear {
      store.send(._onAppear)
    }
  }
}

struct EmptyChallengeListSection_Previews: PreviewProvider {
  static var previews: some View {
    EmptyChallengeListSection(
      store: Store(
        initialState: EmptyChallengeListSectionCore.State(),
        reducer: { EmptyChallengeListSectionCore() }
      )
    )
  }
}
