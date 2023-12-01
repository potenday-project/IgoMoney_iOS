//
//  DetailChallengeResultSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct DetailChallengeResultSection: View {
  let store: StoreOf<ParticipatingChallengeResultSectionCore>
  var body: some View {
    VStack(spacing: 12) {
      DetailChallengeResultCard(
        store: self.store.scope(
          state: \.myChallengeCost,
          action: ParticipatingChallengeResultSectionCore.Action.myChallengeCostAction
        )
      )
      
      Divider()
      
      DetailChallengeResultCard(
        store: self.store.scope(
          state: \.competitorChallengeCost,
          action: ParticipatingChallengeResultSectionCore.Action.competitorChallengeCostAction
        )
      )
      
      Divider()
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.winnerDescription)
          .font(.pretendard(size: 16, weight: .bold))
      }
    }
    .padding(16)
    .background(ColorConstants.primary8)
    .cornerRadius(10)
  }
}

struct ChallengeResultCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    let isMine: Bool
    var cost: Int = .zero
    var userNickName: String = ""
    
    var isFull: Bool {
      return ratio >= 1
    }
    
    init(challenge: Challenge, isMine: Bool) {
      self.challenge = challenge
      self.isMine = isMine
    }
    
    var ratio: Double {
      return Double(cost) / Double(challenge.targetAmount.money)
    }
  }
  
  enum Action: Equatable {
    case onAppear
    case fetchTotalCost
    case fetchUser(userID: Int)
    
    case _fetchTotalCostResponse(TaskResult<ChallengeCostResponse>)
    case _fetchUserNameResponse(TaskResult<User>)
  }
  
  @Dependency(\.userClient) var userClient
  @Dependency(\.challengeClient) var challengeClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(.fetchTotalCost)
      
    case .fetchTotalCost:
      return .run { [challenge = state.challenge, isMine = state.isMine] send in
        await send(
          ._fetchTotalCostResponse(
            TaskResult {
              try await challengeClient.challengeCosts(challenge, isMine)
            }
          )
        )
      }
      
    case .fetchUser(let userID):
      return .run { send in
        await send(
          ._fetchUserNameResponse(
            TaskResult {
              try await userClient.getUserInformation(userID.description)
            }
          )
        )
      }
      
    case ._fetchTotalCostResponse(.success(let response)):
      state.cost = response.totalCost
      return .send(.fetchUser(userID: response.userID))
      
    case ._fetchTotalCostResponse(.failure):
      return .none
      
    case ._fetchUserNameResponse(.success(let user)):
      if let userNickName = user.nickName {
        state.userNickName = userNickName
      }
      
      return .none
      
    case ._fetchUserNameResponse(.failure):
      return .none
    }
  }
}

struct DetailChallengeResultCard: View {
  let store: StoreOf<ChallengeResultCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 8) {
        HStack {
          Text(viewStore.userNickName)
            .font(.pretendard(size: 16, weight: .bold))
          
          Spacer()
          
          Text("누적 금액 \(viewStore.cost)원")
            .font(.pretendard(size: 14, weight: .bold))
            .foregroundColor(viewStore.isFull ? ColorConstants.warning : ColorConstants.primary2)
        }
        
        GeometryReader { proxy in
          let size = proxy.frame(in: .local).size
          
          VStack(alignment: .leading) {
            Image("icon_bolt")
              .offset(x: size.width * (viewStore.ratio >= 1 ? 1 : viewStore.ratio))
              .foregroundColor(viewStore.isFull ? ColorConstants.warning : ColorConstants.primary)
            
            Capsule()
              .fill(ColorConstants.primary6)
              .frame(maxWidth: size.width, maxHeight: 8)
              .overlay(
                Capsule()
                  .fill(viewStore.isFull ? ColorConstants.warning : ColorConstants.primary)
                  .frame(maxWidth: size.width * viewStore.ratio, maxHeight: 8),
                alignment: .leading
              )
            
            HStack {
              Text("\(0)원")
              
              Spacer()
              
              Text("\(viewStore.challenge.targetAmount.money)원")
            }
            .font(.pretendard(size: 12, weight: .medium))
            .foregroundColor(ColorConstants.gray3)
          }
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
    .frame(height: 80)
  }
}

#Preview {
  DetailChallengeResultSection(
    store: Store(
      initialState: ParticipatingChallengeResultSectionCore.State(challenge: .default),
      reducer: { ParticipatingChallengeResultSectionCore() }
    )
  )
}
