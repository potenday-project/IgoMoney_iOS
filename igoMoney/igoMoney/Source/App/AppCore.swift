//
//  AppCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture
import AuthenticationServices

struct AppCore: Reducer {
  enum SessionState {
    case onBoarding
    case auth
    case main
  }
  
  struct State {
    var mainState = MainCore.State()
    var authState = AuthCore.State()
    
    var currentState: SessionState = .onBoarding
  }
  
  enum Action {
    // Inner Action
    case _onAppear
    case _autoSignIn(Bool)
    // Child Action
    case mainAction(MainCore.Action)
    case authAction(AuthCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.mainState, action: /Action.mainAction) {
      MainCore()
    }
    
    Scope(state: \.authState, action: /Action.authAction) {
      AuthCore()
    }
    
    Reduce { state, action in
      switch action {
      case ._onAppear:
//        if state.currentState == .onBoarding {
//          return .run { send in
//            let isSuccess = await autoSignIn()
//            await send(._autoSignIn(isSuccess))
//          }
//        }
        
        state.currentState = .auth
        
        return .none
        
      case ._autoSignIn(true):
        state.currentState = .main
        return .none
        
      case ._autoSignIn(false):
        state.currentState = .auth
        return .none
        
      case .mainAction(.myPageAction(.settingAction(._withdrawResponse(.success)))):
        state.currentState = .auth
        return .none
        
      case .authAction(._presentMainScene):
        state.authState = AuthCore.State()
        state.currentState = .main
        return .none.animation()
        
      default:
        return .none
      }
    }
  }
}

private extension AppCore {
  func autoSignIn() async -> Bool {
    // Provider를 가져온다.
    // Provider에 따라서 함수를 호출한다.
    return (await signInWithApple() == .authorized)
  }
  
  func signInWithApple() async -> ASAuthorizationAppleIDProvider.CredentialState {
    let provider = ASAuthorizationAppleIDProvider()
    
    let state = await withCheckedContinuation { continuation in
      provider.getCredentialState(forUserID: KeyChainClient.currentUserIdentifier) { state, error in
        if let _ = error {
          continuation.resume(
            returning: ASAuthorizationAppleIDProvider.CredentialState.notFound
          )
        }
        
        continuation.resume(returning: state)
      }
    }
    
    return state
  }
}
