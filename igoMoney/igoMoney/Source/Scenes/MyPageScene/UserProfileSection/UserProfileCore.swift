//
//  UserProfileSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct UserProfileCore: Reducer {
  struct State: Equatable {
    var profilePath: String?
    var userName: String = ""
    var myChallengeState = MyChallengeSectionCore.State()
  }
  
  enum Action: Equatable {
    case onAppear
    
    case fetchProfile
    
    // Inner Action
    case _fetchProfileResponse(TaskResult<User>)
    
    // Child Action
    case myChallengeSectionAction(MyChallengeSectionCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.myChallengeState, action: /Action.myChallengeSectionAction) {
      MyChallengeSectionCore()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .concatenate(
          .send(.fetchProfile),
          .send(.myChallengeSectionAction(._onAppear))
        )
        
      case .fetchProfile:
        return .run { send in
          await send(
            ._fetchProfileResponse(
              TaskResult {
                try await userClient.getUserInformation(nil)
              }
            )
          )
        }
        
      case ._fetchProfileResponse(.success(let user)):
        state.profilePath = user.profileImagePath
        state.userName = user.nickName ?? ""
        return .none
        
      case ._fetchProfileResponse(.failure):
        return .none
        
      case .myChallengeSectionAction:
        return .none
      }
    }
  }
}
