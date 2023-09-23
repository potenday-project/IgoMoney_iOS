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
    case didTapLoginButton(Provider)
    
    // Inner Action
    case _loginWithKakao
    case _loginWithApple
    case _setNavigationIsActive
    
    // Child Action
    case signUpAction(SignUpCore.Action)
    case profileSettingAction(ProfileSettingCore.Action)
  }
  
  private enum CancelID { case load }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        // User Action
      case .didTapLoginButton(let provider):
        switch provider {
        case .kakao:
          return .run { send in
            await send(._loginWithKakao)
          }
          
        case .apple:
          return .none
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
        
        // Child Action
      case .signUpAction(.didTapConfirm):
        return .run { send in
          await send(.presentSignUp(false))
          await send(.presentProfileSetting(true))
        }
        
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
