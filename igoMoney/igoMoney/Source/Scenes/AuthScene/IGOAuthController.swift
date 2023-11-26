//
//  AuthController.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import AuthenticationServices
import UIKit

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@MainActor
class IGOAuthController: NSObject {
  static let shared = IGOAuthController()
  
  typealias AppleTokenResponse = (userIdentifier: String, idToken: String, authToken: String)
  typealias AppleToken = (response: AppleTokenResponse?, error: Error?)
  
  private var authToken: OAuthToken?
  var appleCompletion: ((AppleToken) -> Void)?
  
  init(authToken: OAuthToken? = nil) {
    self.authToken = authToken
  }
  
  func authorizationWithApple() async throws -> AppleTokenResponse {
    return try await withCheckedThrowingContinuation { continuation in
      self.appleCompletion = { appleToken in
        if let error = appleToken.error {
          continuation.resume(throwing: error)
          return
        }
        
        if let response = appleToken.response {
          continuation.resume(returning: response)
          return
        }
        
        continuation.resume(throwing: ASAuthorizationError(ASAuthorizationError.invalidResponse))
      }
      
      self.requestAppleAuthController()
    }
  }
  
  func requestAppleAuthController() {
    let IdRequest = ASAuthorizationAppleIDProvider().createRequest()
//    let passwordRequest = ASAuthorizationPasswordProvider().createRequest()
    IdRequest.requestedScopes = [.fullName, .email]
    
    let controller = ASAuthorizationController(authorizationRequests: [IdRequest])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
}

extension IGOAuthController {
  private func requestKakaoLogin(with continuation: CheckedContinuation<OAuthToken, Error>) {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { token, error in
        guard let token = token else {
          continuation.resume(throwing: APIError.badRequest(400))
          return
        }
        continuation.resume(returning: token)
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { token, error in
        guard let token = token else {
          continuation.resume(throwing: APIError.badRequest(400))
          return
        }
        continuation.resume(returning: token)
      }
    }
  }
  
  func authorizationWithKakao() async throws -> OAuthToken {
    try await withCheckedThrowingContinuation { continuation in
      if AuthApi.hasToken() {
        UserApi.shared.accessTokenInfo { tokenInformation, error in
          if let error = error {
            if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
              self.requestKakaoLogin(with: continuation)
            } else {
              continuation.resume(throwing: APIError.badRequest(400))
            }
          } else {
            if let token = TokenManager.manager.getToken() {
              continuation.resume(returning: token)
            } else {
              continuation.resume(throwing: APIError.badRequest(400))
            }
          }
        }
      } else {
        self.requestKakaoLogin(with: continuation)
      }
    }
  }
}

extension IGOAuthController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    appleCompletion?(AppleToken(nil, error))
    appleCompletion = nil
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let idTokenData = credential.identityToken,
            let authData = credential.authorizationCode else {
        return
      }
      
      guard let idToken = String(data: idTokenData, encoding: .utf8),
            let authToken = String(data: authData, encoding: .utf8) else {
        return
      }
      let user = credential.user
      let response = AppleTokenResponse(user, idToken, authToken)
      appleCompletion?(AppleToken(response, nil))
    }
    
  }
}

extension IGOAuthController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.shared.topWindow() ?? ASPresentationAnchor()
  }
}

extension IGOAuthController: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return UIApplication.shared.topWindow() ?? ASPresentationAnchor()
  }
}
