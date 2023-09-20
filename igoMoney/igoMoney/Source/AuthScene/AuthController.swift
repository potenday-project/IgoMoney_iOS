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
    
    private init(authToken: OAuthToken? = nil) {
        self.authToken = authToken
    }
    
    func authorizationWithApple() {
        let IdRequest = ASAuthorizationAppleIDProvider().createRequest()
        let passwordRequest = ASAuthorizationPasswordProvider().createRequest()
        IdRequest.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [IdRequest, passwordRequest])
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
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                // Do Register New Account
            } else {
                // Do Register Exist Account
            }
            
            break
            
        case let passwordCredential as ASPasswordCredential:
            // SIgn In with User And Password
            
            break
            
        default:
            break
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
