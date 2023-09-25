//
//  igoMoneyApp.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import AuthenticationServices
import SwiftUI

import ComposableArchitecture
import KakaoSDKCommon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
  }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(windowScene: windowScene)
    
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    appleIDProvider.getCredentialState(forUserID: KeyChainClient.currentUserIdentifier) { [weak self] status, error in

      switch status {
      case .authorized:
        guard let token = KeyChainClient.read() else {
          fallthrough
        }
        
        DispatchQueue.main.async {
          if token.isExpired {
              self?.showLoginView()
          } else {
            self?.showMainView()
          }
        }
        
      default:
        DispatchQueue.main.async {
          self?.showLoginView()
        }
      }
    }
    
    window?.makeKeyAndVisible()
  }
}

private extension SceneDelegate {
  func showMainView() {
    let rootView = MainScene(
      store: Store(
        initialState: MainCore.State(),
        reducer: { MainCore()._printChanges() }
      )
    )
    
    self.window?.rootViewController = UIHostingController(rootView: rootView)
  }
  
  func showLoginView() {
    let rootView = AuthScene(
      store: Store(
        initialState: AuthCore.State(),
        reducer: { AuthCore()._printChanges() }
      )
    )
    
    self.window?.rootViewController = UIHostingController(rootView: rootView)
  }
}
