//
//  ExploreChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeScene: View {
  @Environment(\.presentationMode) var presentationMode
  let store: StoreOf<ExploreChallengeCore>
  
  var body: some View {
    ZStack {
      VStack(spacing: 16) {
        IGONavigationBar {
          Text("챌린지 둘러보기")
        } leftView: {
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image(systemName: "chevron.left")
          }
        } rightView: {
          Button {
            store.send(.showGenerate(true))
          } label: {
            Image(systemName: "plus.circle")
          }
        }
        .font(.pretendard(size: 20, weight: .bold))
        .padding(.vertical, 16)
        .accentColor(.black)
        .padding(.horizontal, 24)
        
        ExploreChallengeFilterHeaderSection(
          store: self.store.scope(
            state: \.filterState,
            action: ExploreChallengeCore.Action.filterChallengeAction
          )
        )
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 12) {
              ForEachStore(
                store.scope(
                  state: \.challenges,
                  action: ExploreChallengeCore.Action.challengeInformationAction
                )
              ) { store in
                WithViewStore(store, observe: { $0 }) { informationViewStore in
                  NavigationLink(
                    tag: informationViewStore.id,
                    selection: viewStore.binding(
                      get: \.selectedChallengeID,
                      send: ExploreChallengeCore.Action.selectChallenge
                    )
                  ) {
                    IfLetStore(
                      self.store.scope(
                        state: \.selectedChallenge,
                        action: ExploreChallengeCore.Action.enterChallengeAction
                      )
                    ) { enterStore in
                      EnterChallengeScene(store: enterStore)
                    }
                  } label: {
                    ExploreChallengeCellView(store: store)
                  }
                  .buttonStyle(.plain)
                  .onAppear {
                    viewStore.send(.onAppearList(informationViewStore.state))
                  }
                }
              }
              
              if viewStore.isLoading {
                ProgressView()
              }
            }
            .padding(.top)
          }
        }
        .onAppear {
          store.send(._requestFetchChallenges)
        }
      }
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        if viewStore.showFilter {
          GeometryReader { proxy in
            IGOBottomSheetView(
              isOpen: viewStore.binding(
                get: \.showFilter,
                send: ExploreChallengeCore.Action.openFilter
              ),
              maxHeight: proxy.size.height * 0.65
            ) {
              ExploreChallengeFilterView(
                store: self.store.scope(
                  state: \.filterState,
                  action: ExploreChallengeCore.Action.filterChallengeAction
                )
              )
            }
            .edgesIgnoringSafeArea(.all)
          }
        }
      }
    }
    .fullScreenCover(
      isPresented: ViewStore(store, observe: { $0 })
        .binding(
          get: \.showGenerate,
          send: ExploreChallengeCore.Action.showGenerate
        )
    ) {
      GenerateRoomScene(
        store: self.store.scope(
          state: \.generateState,
          action: ExploreChallengeCore.Action.generateChallengeAction
        )
      )
    }
    .navigationBarHidden(true)
  }
}

enum FilterSectionItem: Int, CaseIterable {
  case all
  case challenge
  case money
  
  var description: String {
    switch self {
    case .all:
      return "전체"
    case .challenge:
      return "챌린지 주제"
    case .money:
      return "금액"
    }
  }
  
  var isMenu: Bool {
    return (self == .all) == false
  }
}



struct ExploreChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ExploreChallengeScene(
        store: Store(
          initialState: ExploreChallengeCore.State(),
          reducer: { ExploreChallengeCore() }
        )
      )
    }
  }
}
