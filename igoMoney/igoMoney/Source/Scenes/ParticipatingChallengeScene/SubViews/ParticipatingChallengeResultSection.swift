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
      IfLetStore(
        self.store.scope(
          state: \.myChallengeCost,
          action: ParticipatingChallengeResultSectionCore.Action.myChallengeCostAction
        )
      ) { costStore in
        DetailChallengeResultCard(store: costStore)
      }
      
      Divider()
      
      IfLetStore(
        self.store.scope(
          state: \.competitorChallengeCost,
          action: ParticipatingChallengeResultSectionCore.Action.competitorChallengeCostAction
        )
      ) { costStore in
        DetailChallengeResultCard(store: costStore)
      }
      
      Divider()
      
      WithViewStore(store, observe: { $0.winnerName }) { winner in
        if winner.state.isEmpty {
          Text("같은 금액을 소비하고 있습니다!")
        } else {
          Text("현재 \(winner.state)님이 더 절약하고 있어요")
        }
      }
      .font(.pretendard(size: 16, weight: .bold))
    }
    .padding(16)
    .background(ColorConstants.primary8)
    .cornerRadius(10)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

struct ChallengeResultCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    var user: User?
    var cost: ChallengeCostResponse
    
    init(challenge: Challenge, cost: ChallengeCostResponse) {
      self.challenge = challenge
      self.cost = cost
    }
    
    var ratio: Double {
      return Double(cost.totalCost) / Double(challenge.targetAmount.money)
    }
  }
  
  enum Action: Equatable {
    case onAppear
    case _fetchCurrentUser
    case _fetchCurrentUserResponse(TaskResult<User>)
  }
  
  @Dependency(\.userClient) var userClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(._fetchCurrentUser)
      
    case ._fetchCurrentUser:
      return .run { [userID = state.cost.userID] send in
        await send(
          ._fetchCurrentUserResponse(
            TaskResult {
              try await userClient.getUserInformation(userID.description)
            }
          )
        )
      }
      
    case ._fetchCurrentUserResponse(.success(let user)):
      state.user = user
      return .none
      
    case ._fetchCurrentUserResponse(.failure):
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
          Text(viewStore.user?.nickName ?? "")
            .font(.pretendard(size: 16, weight: .bold))
          
          Spacer()
          
          Text("누적 금액 \(viewStore.cost.totalCost)원")
            .font(.pretendard(size: 14, weight: .bold))
            .foregroundColor(ColorConstants.primary2)
        }
        
        GeometryReader { proxy in
          let size = proxy.frame(in: .local).size
          
          VStack(alignment: .leading) {
            Image("icon_bolt")
              .offset(x: size.width * viewStore.ratio)
            
            Capsule()
              .fill(ColorConstants.primary6)
              .frame(width: size.width, height: 8)
              .overlay(
                Capsule()
                  .fill(ColorConstants.primary)
                  .frame(width: size.width * viewStore.ratio, height: 8),
                alignment: .leading
              )
            
            HStack {
              Text("\(viewStore.cost.totalCost)원")
              
              Spacer()
              
              Text("\(viewStore.challenge.targetAmount.money)원")
            }
            .font(.pretendard(size: 12, weight: .medium))
            .foregroundColor(ColorConstants.gray3)
          }
        }
      }
    }
    .frame(height: 80)
    .onAppear {
      store.send(.onAppear)
    }
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
