//
//  ChallengeCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture
import SwiftUI

struct HomeCore: Reducer {
  struct State: Equatable {
    var myChallengeState = MyChallengeSectionCore.State()
    var emptyChallengeListState = EmptyChallengeListSectionCore.State()
    var notificationState = NotificationCore.State()
  }
  
  enum Action {
    // Child Action
    case myChallengeAction(MyChallengeSectionCore.Action)
    case emptyChallengeAction(EmptyChallengeListSectionCore.Action)
    case notificationAction(NotificationCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .myChallengeAction:
        return .none
        
      case .emptyChallengeAction:
        return .none
        
      case .notificationAction:
        return .none
      }
    }
    
    Scope(state: \.myChallengeState, action: /Action.myChallengeAction) {
      MyChallengeSectionCore()
    }
    
    Scope(state: \.emptyChallengeListState, action: /Action.emptyChallengeAction) {
      EmptyChallengeListSectionCore()
    }
    
    Scope(state: \.notificationState, action: /Action.notificationAction) {
      NotificationCore()
    }
  }
}
