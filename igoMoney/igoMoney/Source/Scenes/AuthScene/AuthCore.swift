//
//  AuthCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import AuthenticationServices

import ComposableArchitecture
import KakaoSDKAuth
import KakaoSDKUser

struct AuthCore: Reducer {
  struct State: Equatable {
    var currentUser: User? = nil
    
    let providers: [Provider] = Provider.allCases
    var showSignUp: Bool = false
    var isNavigationBarHidden: Bool = true
    var showProfileSetting: Bool = false
    
    var signUpState = AgreeTermsCore.State()
    var profileSettingState: ProfileSettingCore.State?
  }
  
  enum Action: Equatable {
    // User Action
    case autoSignIn
    case presentSignUp(Bool)
    case presentProfileSetting(Bool)
    case didTapKakaoLogin(token: String)
    case didTapAppleLogin(user: String, identityCode: String, authCode: String)
    case refreshToken
    
    // Inner Action
    case _setNavigationIsActive
    case _authTokenResponse(TaskResult<AuthToken>)
    case _userInformationResponse(TaskResult<User>)
    case _presentMainScene
    
    // Child Action
    case signUpAction(AgreeTermsCore.Action)
    case profileSettingAction(ProfileSettingCore.Action)
  }
  
  @Dependency(\.authClient) var authClient
  @Dependency(\.userClient) var userClient
  
  private enum CancelID { case load }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.signUpState, action: /Action.signUpAction) {
      AgreeTermsCore()
    }
    
    Reduce { state, action in
      switch action {
        // User Action
      case .autoSignIn:
        return .run { send in
          await send(
            ._authTokenResponse(
              TaskResult {
                try await autoSignIn()
              }
            )
          )
        }
        
      case let .didTapKakaoLogin(token):        
        return .run { send in
          await send(
            ._authTokenResponse(
              TaskResult {
                try await authClient.signInWithKakao(token)
              }
            )
          )
        }
      case let .didTapAppleLogin(user, identityCode, authCode):
        return .run { send in
          await send(
            ._authTokenResponse(
              TaskResult {
                try await authClient.signInWithApple(user, identityCode, authCode)
              }
            )
          )
        }
        
      case .refreshToken:
        return .run { send in
          await send(
            ._authTokenResponse(
              TaskResult {
                try await authClient.refreshToken()
              }
            )
          )
        }
        
      case .presentSignUp(true):
        state.showSignUp = true
        state.signUpState = AgreeTermsCore.State()
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
        if state.currentUser?.userID == nil {
          return .none
        }
        
        state.profileSettingState = ProfileSettingCore.State(
          profileImageState: .init(),
          nickNameState: .init()
        )
        return .none
        
      case let ._authTokenResponse(.success(token)):
        print(#fileID, #function, #line, "🐯", token)
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
        if case .tokenExpired = error as? APIError {
          return .send(.refreshToken)
        }
        
        return .send(._userInformationResponse(.failure(error)))
        
      case ._userInformationResponse(.success(let user)):
        state.currentUser = user
        guard let nickName = user.nickName else {
          // 닉네임이 없는 경우
          return .send(.presentSignUp(true))
        }
        
        // 닉네임이 있는 경우
        return .send(._presentMainScene)
        
      case ._userInformationResponse(.failure):
        return .send(.presentSignUp(true))
        
        // Child Action
      case .signUpAction(.didTapConfirm):
        return .concatenate(
          .send(.presentSignUp(false)),
          .send(.presentProfileSetting(true))
        )
        
      case .profileSettingAction(._updateProfileResponse(.success)):
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

private extension AuthCore {
  func autoSignIn() async throws -> AuthToken {
    guard let token: AuthToken = try? KeyChainClient.read(.token, SystemConfigConstants.tokenService)
      .toDecodable() else {
      throw APIError.tokenExpired
    }
    
    switch token.provider {
    case .apple:
      try await signInWithApple()
      return token
      
    case .kakao:
      try await signInWithKakao()
      return token
      
    default:
      throw APIError.tokenExpired
    }
  }
  
  func signInWithKakao() async throws {
    return try await withCheckedThrowingContinuation { continuation in
      UserApi.shared.accessTokenInfo { token, error in
        print(token)
        if let error = error {
          continuation.resume(throwing: APIError.badRequest(400))
          return
        }
        continuation.resume()
      }
    }
  }
  
  func signInWithApple() async throws {
    let provider = ASAuthorizationAppleIDProvider()
    
    guard let userIdentifier = try? KeyChainClient.read(
      .userIdentifier,
      SystemConfigConstants.userIdentifierService
    ) else {
      throw APIError.badRequest(400)
    }
    
    return try await withCheckedThrowingContinuation { continuation in
      provider.getCredentialState(forUserID: userIdentifier.toString()) { state, error in
        if let error = error {
          continuation.resume(throwing: error)
        }
        
        continuation.resume()
      }
    }
  }
}
