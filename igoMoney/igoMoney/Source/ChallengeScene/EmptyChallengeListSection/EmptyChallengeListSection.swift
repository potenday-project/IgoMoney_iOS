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
          
          ChallengeSectionTitleView(sectionType: .emptyChallenge) {
            store.send(.showExplore(true))
          }
        }
      }
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        LazyVGrid(columns: generateGridItem(count: 2, spacing: 16), spacing: 16) {
          ForEach(viewStore.challenges, id: \.id) { challenge in
            NavigationLink(
              destination: EnterChallengeScene(
                store: Store(
                  initialState: EnterChallengeCore.State(challenge: challenge),
                  reducer: { EnterChallengeCore()._printChanges() }
                )
              )
            ) {
              EmptyChallengeDetail(
                store: Store(
                  initialState: ChallengeDetailCore.State(challenge: challenge),
                  reducer: { ChallengeDetailCore() }
                )
              )
            }
          }
          
          CreateChallengeButton()
            .onTapGesture {
              // TODO: - 챌린지 생성 화면 이동 메서드 구현
            }
        }
      }
    }
    .onAppear {
      store.send(._onAppear)
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
