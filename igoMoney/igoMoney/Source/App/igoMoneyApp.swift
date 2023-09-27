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

struct AppCore: Reducer {
  enum State {
    case logIn(MainCore.State)
    case logOut(AuthCore.State)
  }
  
  enum Action {
    case mainAction(MainCore.Action)
    case authAction(AuthCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: /State.logIn, action: /Action.mainAction) {
      MainCore()
    }
    
    Scope(state: /State.logOut, action: /Action.authAction) {
      AuthCore()
    }
    
    Reduce { state, action in
      switch action {
      case .authAction(._presentMainScene):
        state = .logIn(MainCore.State())
        return .none
      default:
        return .none
      }
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppCore>
  
  var body: some View {
    SwitchStore(store) { state in
      switch state {
      case .logIn:
        CaseLet(
          /AppCore.State.logIn,
          action: AppCore.Action.mainAction
        ) { store in
          MainScene(store: store)
        }
        
      case .logOut:
        CaseLet(
          /AppCore.State.logOut,
          action: AppCore.Action.authAction
        ) { store in
          AuthScene(store: store)
        }
      }
    }
  }
}

#Preview {
  AppView(
    store: Store(
      initialState: AppCore.State.logIn(.init()),
      reducer: { AppCore() }
    )
  )
}
