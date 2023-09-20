//
//  SignInWithAppleDelegate.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import AuthenticationServices

class SignInWithAppleDelegate: NSObject {
    private let signInSucceeded: (Bool) -> Void
    private weak var window: UIWindow?
    
    init(window: UIWindow?, onSignIn: @escaping (Bool) -> Void) {
        self.window = window
        self.signInSucceeded = onSignIn
    }
}

extension SignInWithAppleDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                print("Register ID")
                let identityTokenData = appleIdCredential.identityToken
                let authTokenData = appleIdCredential.authorizationCode
                
//                print("identityToken", String(data: identityTokenData!, encoding: .utf8), "authorizationToken", String(data: authTokenData!, encoding: .utf8))
            } else {
                print("Sign In With Existing Account")
            }
            break
            
        case let passwordCredential as ASPasswordCredential:
            print("Sign In With Password")
            
            break
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension SignInWithAppleDelegate: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.window else { return UIApplication.shared.windows.first! }
        return window
    }
}
