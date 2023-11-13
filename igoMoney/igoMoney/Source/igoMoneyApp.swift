//
//  igoMoneyApp.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import AuthenticationServices
import SwiftUI

import ComposableArchitecture
import KakaoSDKCommon
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeKey)
    
    UNUserNotificationCenter.current().delegate = self
    
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )
    
    application.registerForRemoteNotifications()
    
    return true
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  
}

@main
struct igoMoneyApp: App {
  @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
  
  var body: some Scene {
    WindowGroup {
      AppScene(
        store: Store(
          initialState: AppCore.State(),
          reducer: { AppCore()._printChanges() }
        )
      )
    }
  }
}
