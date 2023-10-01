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
  private var authToken: OAuthToken?
  var appleCompletion: ((_ userIdentifier: String, _ idToken: String, _ authToken: String) -> Void)?
  
  init(authToken: OAuthToken? = nil) {
    self.authToken = authToken
  }
  
  func authorizationWithApple() {
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
    // Handling Apple Sign Error
    print(error)
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
      appleCompletion?(user, idToken, authToken)
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
