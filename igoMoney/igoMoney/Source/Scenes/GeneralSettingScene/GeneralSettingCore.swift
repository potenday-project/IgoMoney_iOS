//
//  SettingCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct GeneralSettingCore: Reducer {
  struct State: Equatable {
    let settings = Setting.allCases
    var appVersion: String = ""
    var showAuthSetting: Bool = false
    
    var authSettingState = AuthSettingCore.State()
    var serviceAlertState = GeneralToggleReducer.State(setting: .serviceAlert)
    var marketingAlertState = GeneralToggleReducer.State(setting: .marketingAlert)
  }
  
  enum Action {
    case onAppear
    case presentAuthSetting(Bool)
    
    case _fetchAppVersion
    
    case authSettingAction(AuthSettingCore.Action)
    case serviceAlertAction(GeneralToggleReducer.Action)
    case marketingAlertAction(GeneralToggleReducer.Action)
  }
  
  @Dependency(\.authClient) var authClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.authSettingState, action: /Action.authSettingAction) {
      AuthSettingCore()
    }
    
    Scope(state: \.serviceAlertState, action: /Action.serviceAlertAction) {
      GeneralToggleReducer()
    }
    
    Scope(state: \.marketingAlertState, action: /Action.marketingAlertAction) {
      GeneralToggleReducer()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(._fetchAppVersion)
        
      case .presentAuthSetting(let isPresent):
        state.showAuthSetting = isPresent
        return .none
        
      case ._fetchAppVersion:
        if let appInformation = Bundle.main.infoDictionary,
           let version = appInformation["CFBundleShortVersionString"] as? String,
           let build = appInformation["CFBundleVersion"] as? String {
          state.appVersion = version + "(\(build))"
        }
        return .none
        
      case .authSettingAction:
        return .none
        
      case .serviceAlertAction:
        return .none
        
      case .marketingAlertAction:
        return .none
      }
    }
  }
}
