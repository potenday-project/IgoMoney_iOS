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
      WithViewStore(store, observe: { $0 }) { viewStore in
        ZStack {
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
          
          NavigationLink(
            isActive: viewStore.binding(
              get: { $0.enterSelection != nil },
              send: { newValue in
                let challengeValue = (newValue ? viewStore.enterSelection?.challengeInformationState.challenge : nil)
                return .showEnter(challengeValue)
              }
            )
          ) {
            IfLetStore(
              self.store.scope(
                state: \.enterSelection,
                action: EmptyChallengeListSectionCore.Action.enterAction
              )
            ) { store in
              EnterChallengeScene(store: store)
            }
          } label: {
            EmptyView()
          }
          
          ChallengeSectionTitleView(sectionType: .emptyChallenge) {
            store.send(.showExplore(true))
          }
        }
      }
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        LazyVGrid(columns: generateGridItem(count: 2, spacing: 16), spacing: 16) {
          ForEach(viewStore.challenges, id: \.id) { challenge in
            EmptyChallengeDetail(
              store: Store(
                initialState: ChallengeDetailCore.State(challenge: challenge),
                reducer: { ChallengeDetailCore() }
              )
            )
            .onTapGesture {
              viewStore.send(.showEnter(challenge))
            }
          }
          
          CreateChallengeButton()
            .onTapGesture {
              viewStore.send(.showGenerate(true))
            }
        }
      }
    }
    .onAppear {
      store.send(._onAppear)
    }
    .fullScreenCover(
      isPresented: ViewStore(store, observe: { $0 })
        .binding(
          get: \.showGenerate,
          send: EmptyChallengeListSectionCore.Action.showGenerate
        )
    ) {
      GenerateRoomScene()
    }
  }
}

struct CreateChallengeButton: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("직접 챌린지\n방만들어보기")
        .font(.pretendard(size: 16, weight: .semiBold))
        .lineHeight(font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
      
      Spacer()
      
      HStack {
        Spacer()
        
        Image("icon_add_task")
      }
    }
    .padding(16)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(ColorConstants.primary8)
        .shadow(
          color: ColorConstants.gray2.opacity(0.15),
          radius: 4,
          y: 2
        )
    )
    .frame(minHeight: 190)
  }
}

struct EmptyChallengeListSection_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EmptyChallengeListSection(
        store: Store(
          initialState: EmptyChallengeListSectionCore.State(),
          reducer: { EmptyChallengeListSectionCore() }
        )
      )
    }
    .navigationViewStyle(.stack)
  }
}
