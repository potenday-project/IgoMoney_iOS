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
class AuthController: NSObject {
  static let shared = AuthController()
  
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

extension AuthController {
  func authorizationWithKakao() async -> OAuthToken {
    await withCheckedContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        UserApi.shared.loginWithKakaoTalk { token, error in
          guard let token = token else { return }
          
          continuation.resume(returning: token)
        }
      } else {
        UserApi.shared.loginWithKakaoAccount { token, error in
          guard let token = token else { return }
          
          continuation.resume(returning: token)
        }
      }
    }
  }
}

extension AuthController: ASAuthorizationControllerDelegate {
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

extension AuthController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.shared.topWindow() ?? ASPresentationAnchor()
  }
}

extension AuthController: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return UIApplication.shared.topWindow() ?? ASPresentationAnchor()
  }
}
