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
    let providers: [Provider] = Provider.allCases
    var showSignUp: Bool = false
    var isNavigationBarHidden: Bool = true
    var showProfileSetting: Bool = false
    
    var signUpState: SignUpCore.State?
    var profileSettingState: ProfileSettingCore.State?
  }
  
  enum Action: Equatable {
    // User Action
    case presentSignUp(Bool)
    case presentProfileSetting(Bool)
    case didTapKakaoLogin
    case didTapAppleLogin(user: String, identityCode: String, authCode: String)
    
    // Inner Action
    case _loginWithKakao
    case _loginWithApple
    case _setNavigationIsActive
    case _authTokenResponse(TaskResult<AuthToken>)
    case _userInformationResponse(TaskResult<User>)
    
    // Child Action
    case signUpAction(SignUpCore.Action)
    case profileSettingAction(ProfileSettingCore.Action)
  }
  
  @Dependency(\.userClient) var userClient
  
  private enum CancelID { case load }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        // User Action
      case ._loginWithKakao:
        return .none
        
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
        state.signUpState = nil
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
      case ._loginWithKakao:
        return .run { send in
          await send(.presentSignUp(true))
        }
        
      case ._loginWithApple:
        return .run { send in
          await send(.presentSignUp(true))
        }
        
      case ._setNavigationIsActive:
        state.profileSettingState = ProfileSettingCore.State()
        return .none
        
      case ._authTokenResponse(.success):
        return .run { send in
          await send(
            ._userInformationResponse(
              TaskResult {
                try await userClient.getUserInformation("2")
              }
            )
          )
        }
        
      case ._authTokenResponse(.failure(let error)):
        print(error)
        return .none
        
      case ._userInformationResponse(.success(let user)):
        if user.nickName == nil {
          return .run { send in
            await send(.presentSignUp(true))
          }
        } else {
          return .run { send in
            await send(.profileSettingAction(.startChallenge), animation: .easeIn(duration: 0.1))
          }
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
        
      case .profileSettingAction(.startChallenge):
        let keyWindow = UIApplication.shared.topWindow()
        
        keyWindow?.rootViewController = UIHostingController(
          rootView: MainScene(
            store: Store(
              initialState: MainCore.State(),
              reducer: { MainCore() }
            )
          )
        )
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.signUpState, action: /Action.signUpAction) {
      SignUpCore()
    }
    .ifLet(\.profileSettingState, action: /Action.profileSettingAction) {
      ProfileSettingCore()
    }
  }
}
