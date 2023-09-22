//
//  igoMoneyApp.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

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
    //        let rootView = AuthScene(
    //            store: Store(
    //                initialState : AuthCore.State(),
    //                reducer: { AuthCore()._printChanges() }
    //            )
    //        )
    
    let rootView = MainScene(
      store: Store(
        initialState: MainCore.State(),
        reducer: { MainCore()._printChanges() }
      )
    )
    
    KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeKey)
    window?.rootViewController = UIHostingController(rootView: rootView)
    window?.makeKeyAndVisible()
  }
}
