//
//  igoMoneyApp.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import AuthenticationServices
import SwiftUI

import ComposableArchitecture
import KakaoSDKCommon

@main
struct igoMoneyApp: App {
  init() {
    KakaoSDK.initSDK(appKey: Bundle.main.kakaoNativeKey)
  }
  
  var body: some Scene {
    WindowGroup {
      AppView(
        store: Store(
          initialState: AppCore.State.logOut(AuthCore.State()),
          reducer: { AppCore()._printChanges() }
        )
      )
    }
  }
}
