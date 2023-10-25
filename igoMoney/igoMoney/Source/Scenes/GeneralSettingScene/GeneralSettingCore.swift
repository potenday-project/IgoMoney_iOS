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
    
    var serviceAlertState = GeneralToggleReducer.State(setting: .serviceAlert)
    var marketingAlertState = GeneralToggleReducer.State(setting: .marketingAlert)
  }
  
  enum Action {
    case onAppear
    
    case _fetchAppVersion
    
    case serviceAlertAction(GeneralToggleReducer.Action)
    case marketingAlertAction(GeneralToggleReducer.Action)
  }
  
  @Dependency(\.authClient) var authClient
  
  var body: some Reducer<State, Action> {
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
        
      case ._fetchAppVersion:
        if let appInformation = Bundle.main.infoDictionary,
           let version = appInformation["CFBundleShortVersionString"] as? String,
           let build = appInformation["CFBundleVersion"] as? String {
          state.appVersion = version + "(\(build))"
        }
        return .none
        
      case .serviceAlertAction:
        return .none
        
      case .marketingAlertAction:
        return .none
      }
    }
  }
}
