//
//  CreateChallengeAuthCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import ComposableArchitecture

struct CreateChallengeAuthCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    var title: String = ""
    var money: String = ""
    var content: String = ""
    var authImages: [UIImage] = []
    
    var isShowImagePicker: Bool = false
    
    init(challenge: Challenge) {
      self.challenge = challenge
    }
  }
  
  enum Action: Equatable {
    case showPicker(Bool)
    case titleChanged(String)
    case moneyChanged(String)
    case contentChanged(String)
    case imageAdd(UIImage)
    case imageRemove(UIImage)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .showPicker(true):
      state.isShowImagePicker = true
      return .none
      
    case .showPicker(false):
      state.isShowImagePicker = false
      return .none
      
    case let .titleChanged(title):
      state.title = title
      return .none
      
    case let .moneyChanged(changedString):
      state.money = changedString.map { String($0) }.compactMap { Int($0) }
        .map { String($0) }.joined()
      return .none
      
    case let .contentChanged(content):
      state.content = content
      return .none
      
    case let .imageAdd(image):
      state.authImages.append(image)
      return .none
      
    case let .imageRemove(image):
      state.authImages.removeAll(where: { $0 == image })
      return .none
    }
  }
}
