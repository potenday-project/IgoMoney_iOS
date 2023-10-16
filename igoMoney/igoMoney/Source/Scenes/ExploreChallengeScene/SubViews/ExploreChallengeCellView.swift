//
//  ExploreChallengeCellView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeCellView: View {
  let challenge: Challenge
  let store: StoreOf<ExploreChallengeCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        ExploreChallengeDetail(challenge: challenge)
          .onTapGesture {
            viewStore.send(._setNavigation(selection: challenge.id))
          }
        
        NavigationLink(
          destination: IfLetStore(
            self.store.scope(
              state: \.selection?.value,
              action: ExploreChallengeCore.Action.enterAction
            )
          ) {
            EnterChallengeScene(store: $0)
              .navigationBarHidden(true)
          },
          tag: challenge.id,
          selection: viewStore.binding(
            get: \.selection?.id,
            send: ExploreChallengeCore.Action._setNavigation
          )
        ) {
          EmptyView()
        }
      }
    }
  }
}
