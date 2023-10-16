//
//  AppCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture
import KakaoSDKUser
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
    case _presentAuth
    case _presentMain
    
    // Child Action
    case mainAction(MainCore.Action)
    case authAction(AuthCore.Action)
  }
  
  @Dependency(\.keyChainClient) var keyChainClient
  
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
        return .run { send in
          await send(
            ._autoSignIn(
              await autoSignIn()
            )
          )
        }
        
      case ._autoSignIn(true):
        return .run { send in
          await send(._presentMain)
        }
        
      case ._autoSignIn(false):
        return .run { send in
          await send(._presentAuth)
        }
        
      case ._presentMain:
        state.currentState = .main
        return .none
        
      case ._presentAuth:
        state.currentState = .auth
        return .none
        
      case .mainAction(.myPageAction(.settingAction(._removeTokenResponse(.success)))),
          .mainAction(.myPageAction(.settingAction(._removeUserIdentifierResponse(.success)))):
        return .run { send in
          await send(._presentAuth)
        }
        
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
    guard let token: AuthToken = try? KeyChainClient.read(.token, SystemConfigConstants.tokenService)
      .toDecodable() else {
      return false
    }
    
    switch token.provider {
    case .apple:
      return (await signInWithApple() == .authorized)
      
    case .kakao:
      return await signInWithKakao()
      
    default:
      return false
    }
  }
  
  func signInWithKakao() async -> Bool {
    await withCheckedContinuation { continuation in
      UserApi.shared.accessTokenInfo { token, error in
        if let error = error {
          continuation.resume(returning: false)
          return
        }
        
        continuation.resume(returning: true)
      }
    }
  }
  
  func signInWithApple() async -> ASAuthorizationAppleIDProvider.CredentialState {
    @Dependency(\.keyChainClient) var keyChainClient
    
    let provider = ASAuthorizationAppleIDProvider()
    
    guard let userIdentifier = try? KeyChainClient.read(
      .userIdentifier,
      SystemConfigConstants.userIdentifierService
    ) else {
      return .notFound
    }
    
    let state = await withCheckedContinuation { continuation in
      provider.getCredentialState(forUserID: userIdentifier.toString()) { state, error in
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
