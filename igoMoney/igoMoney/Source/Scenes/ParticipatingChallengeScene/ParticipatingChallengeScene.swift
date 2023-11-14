//
//  ParticipatingChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.


import SwiftUI

import ComposableArchitecture

struct ParticipatingChallengeScene: View {
  let store: StoreOf<ParticipatingChallengeCore>
  var body: some View {
    ZStack {
      Color("background_color")
        .edgesIgnoringSafeArea(.top)
      
      VStack {
        Spacer()
        
        Color.white
          .frame(maxHeight: 200)
      }
      
      VStack(spacing: 24) {
        IGONavigationBar {
          EmptyView()
        } leftView: {
          Text("참여중인 챌린지")
        } rightView: {
          Button {
            
          } label: {
            Image(systemName: "ellipsis")
          }
        }
        .foregroundColor(.white)
        .font(.pretendard(size: 20, weight: .bold))
        .buttonStyle(.plain)
        .padding(.top, 16)
        .padding(.horizontal, 24)
        
        ScrollView(.vertical, showsIndicators: false) {
          VStack {
            DetailChallengeInformationCard(
              store: self.store.scope(
                state: \.challengeInformationState,
                action: ParticipatingChallengeCore.Action.challengeInformationAction
              )
            )
            .padding(.horizontal, 24)
            
            DetailChallengeResultSection(
              store: self.store.scope(
                state: \.challengeResultSectionState,
                action: ParticipatingChallengeCore.Action.challengeResultSectionAction
              )
            )
            .padding(.horizontal, 24)
            
            ChallengeRecordSection(
              store: self.store.scope(
                state: \.challengeAuthListState,
                action: ParticipatingChallengeCore.Action.challengeAuthListAction
              )
            )
            .cornerRadius(20, corner: .topLeft)
            .cornerRadius(20, corner: .topRight)
          }
        }
        .edgesIgnoringSafeArea(.bottom)
      }
      .disabled(store.withState(\.isSelected))
      
      IfLetStore(
        self.store.scope(
          state: \.selectedChallengeRecordState,
          action: ParticipatingChallengeCore.Action.selectedChallengeRecordAction
        )
      ) { store in
        ZStack {
          Color.black.opacity(0.8)
            .edgesIgnoringSafeArea(.all)
          
          ChallengeDetailDialog(store: store)
        }
      }
    }
    .navigationBarHidden(true)
  }
}

struct DetailChallengeInformationCard: View {
  let store: StoreOf<ChallengeInformationCore>
  
  var body: some View {
    HStack(alignment: .top) {
      WithViewStore(store, observe: { $0 }) { viewStore in
        URLImage(
          store: self.store.scope(
            state: \.urlImageState,
            action: ChallengeInformationCore.Action.urlImageAction
          )
        )
        .scaledToFill()
        .frame(width: 50, height: 50)
        
        VStack(alignment: .leading, spacing: 4) {
          Text(viewStore.challenge.userDescription)
            .font(.pretendard(size: 14, weight: .bold))
            .foregroundColor(ColorConstants.gray2)
          
          VStack(alignment: .leading, spacing: 2) {
            Text(viewStore.challenge.title)
              .font(.pretendard(size: 16, weight: .bold))
            
            HStack {
              Text(viewStore.challenge.targetAmount.description)
                .padding(.horizontal, 4)
                .background(ColorConstants.yellow)
                .cornerRadius(4)
              
              Text(viewStore.challenge.category?.description ?? "")
                .padding(.horizontal, 4)
                .background(ColorConstants.red)
                .cornerRadius(4)
              
              Text(viewStore.challenge.startDate?.toString(with: "M월dd일 시작") ?? "")
                .padding(.horizontal, 4)
                .background(ColorConstants.primary8)
                .cornerRadius(4)
            }
          }
        }
      }
      
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .padding(16)
    .background(Color.white)
    .cornerRadius(10)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  ParticipatingChallengeScene(
    store: Store(
      initialState: ParticipatingChallengeCore.State(challenge: .default),
      reducer: { ParticipatingChallengeCore() }
    )
  )
}
