//
//  UserProfileSectionCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct UserProfileCore: Reducer {
  struct State: Equatable {
    var userName: String = ""
    var profileImageState = URLImageCore.State()
    var myChallengeState = MyChallengeSectionCore.State()
  }
  
  enum Action: Equatable {
    case onAppear
    
    case fetchProfile
    
    // Inner Action
    case _fetchProfileResponse(TaskResult<User>)
    case _setProfileImagePath(String?)
    case _setUserName(String?)
    
    // Child Action
    case profileImageAction(URLImageCore.Action)
    case myChallengeSectionAction(MyChallengeSectionCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.myChallengeState, action: /Action.myChallengeSectionAction) {
      MyChallengeSectionCore()
    }
    
    Scope(state: \.profileImageState, action: /Action.profileImageAction) {
      URLImageCore()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .concatenate(
          .send(.fetchProfile)
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
        return .concatenate(
          .send(._setUserName(user.nickName)),
          .send(._setProfileImagePath(user.profileImagePath))
        )
        
      case ._fetchProfileResponse(.failure):
        return .none
        
      case ._setUserName(let userName):
        state.userName = userName ?? ""
        return .none
        
      case ._setProfileImagePath(let profilePath):
        return .send(.profileImageAction(._setURLPath(profilePath)))
        
      case .myChallengeSectionAction:
        return .none
        
      case .profileImageAction:
        return .none
      }
    }
  }
}
