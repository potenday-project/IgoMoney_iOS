//
//  SignUpCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct AgreeTermsCore: Reducer {
  struct State: Equatable {
    var isAgreePrivacy: Bool = false
    var isAgreeTerms: Bool = false
    
    var isAgreeAll: Bool {
      return isAgreePrivacy && isAgreeTerms
    }
  }
  
  enum Action: Equatable {
    case didTapAll
    case didTapAgreePrivacy
    case didTapAgreeTerms
    case didTapConfirm
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .didTapAll:
        if state.isAgreePrivacy && state.isAgreeTerms {
          state.isAgreePrivacy.toggle()
          state.isAgreeTerms.toggle()
          return .none
        }
        
        if state.isAgreePrivacy == false {
          state.isAgreePrivacy.toggle()
        }
        
        if state.isAgreeTerms == false {
          state.isAgreeTerms.toggle()
        }
        
        return .none
        
      case .didTapAgreePrivacy:
        state.isAgreePrivacy.toggle()
        return .none
        
      case .didTapAgreeTerms:
        state.isAgreeTerms.toggle()
        return .none
        
      case .didTapConfirm:
        return .none
      }
    }
  }
}
