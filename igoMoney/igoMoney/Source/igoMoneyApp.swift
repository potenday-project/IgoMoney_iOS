//
//  igoMoneyApp.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import AuthenticationServices
import SwiftUI

import ComposableArchitecture
import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import FirebaseMessaging

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
    
    Messaging.messaging().delegate = self
    application.applicationIconBadgeNumber = .zero
    return true
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    #if DEBUG
    Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
    #else
    Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
    #endif
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.list, .sound, .banner]
  }
  
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async { return }
}

extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) { debugPrint("Notification Message Receive Token") }
}

@main
struct igoMoneyApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      AppScene(
        store: Store(
          initialState: AppCore.State(),
          reducer: { AppCore()._printChanges() }
        )
      )
      .onOpenURL { url in
        if AuthApi.isKakaoTalkLoginUrl(url) {
          _ = AuthController.handleOpenUrl(url: url)
        }
      }
    }
  }
}
