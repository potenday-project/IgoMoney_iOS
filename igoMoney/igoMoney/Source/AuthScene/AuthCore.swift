//
//  AuthCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import AuthenticationServices

import ComposableArchitecture
import SwiftUI

struct AuthCore: Reducer {
  struct State: Equatable {
    var currentUser: User? = nil
    
    let providers: [Provider] = Provider.allCases
    var showSignUp: Bool = false
    var isNavigationBarHidden: Bool = true
    var showProfileSetting: Bool = false
    
    var signUpState = SignUpCore.State()
    var profileSettingState: ProfileSettingCore.State?
  }
  
  enum Action: Equatable {
    // User Action
    case presentSignUp(Bool)
    case presentProfileSetting(Bool)
    case didTapKakaoLogin(token: String)
    case didTapAppleLogin(user: String, identityCode: String, authCode: String)
    
    // Inner Action
    case _onAppear
    case _setNavigationIsActive
    case _authTokenResponse(TaskResult<AuthToken>)
    case _userInformationResponse(TaskResult<User>)
    case _presentMainScene
    
    // Child Action
    case signUpAction(SignUpCore.Action)
    case profileSettingAction(ProfileSettingCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  
  private enum CancelID { case load }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.signUpState, action: /Action.signUpAction) {
      SignUpCore()
    }
    
    Reduce { state, action in
      switch action {
      // User Action
      case let .didTapKakaoLogin(token):
        return .run { send in
          await send(
            ._authTokenResponse(
              TaskResult {
                try await userClient.signInKakao(token)
              }
            )
          )
        }
      case let .didTapAppleLogin(user, identityCode, authCode):
        return .run { send in
          await send(
            ._authTokenResponse(
              TaskResult {
                try await userClient.signInApple(user, identityCode, authCode)
              }
            )
          )
        }
        
      case .presentSignUp(true):
        state.showSignUp = true
        state.signUpState = SignUpCore.State()
        return .none
        
      case .presentSignUp(false):
        state.showSignUp = false
        return .none
        
      case .presentProfileSetting(true):
        state.showProfileSetting = true
        return .run { send in
          await send(._setNavigationIsActive)
        }
        .cancellable(id: CancelID.load)
        
      case .presentProfileSetting(false):
        state.showProfileSetting = false
        state.profileSettingState = nil
        return .cancel(id: CancelID.load)
        
      // Inner Action
      case ._setNavigationIsActive:
        guard let userID = state.currentUser?.userID else { return .none }
        state.profileSettingState = ProfileSettingCore.State(userID: userID.description)
        return .none
        
      case let ._authTokenResponse(.success(token)):
        return .run { send in
          await send(
            ._userInformationResponse(
              TaskResult {
                try await userClient.getUserInformation(token.userID.description)
              }
            )
          )
        }
        
      case ._authTokenResponse(.failure(let error)):
        print(error)
        return .none
        
      case ._userInformationResponse(.success(let user)):
        state.currentUser = user
        guard let nickName = user.nickName else {
          // 닉네임이 없는 경우
          return .run { send in
            await send(.presentSignUp(true))
          }
        }
        
        // 닉네임이 있는 경우
        return .run { send in
          await send(._presentMainScene)
        }
        
      case ._userInformationResponse(.failure):
        print("Error in User Information Response")
        return .none
        
        // Child Action
      case .signUpAction(.didTapConfirm):
        return .run { send in
          await send(.presentSignUp(false))
          await send(.presentProfileSetting(true))
        }
        
      case .profileSettingAction(._updateNickNameResponse(.success)):
        return .run {
          await $0(._presentMainScene)
        }
        
      default:
        return .none
      }
    }
    .ifLet(\.profileSettingState, action: /Action.profileSettingAction) {
      ProfileSettingCore()
    }
  }
}
