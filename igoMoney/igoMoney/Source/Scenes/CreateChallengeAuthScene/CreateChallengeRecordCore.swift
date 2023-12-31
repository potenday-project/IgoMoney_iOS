//
//  CreateChallengeAuthCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import ComposableArchitecture

struct CreateChallengeRecordCore: Reducer {
  struct State: Equatable {
    let challenge: Challenge
    let selectedDate: String
    
    var dateDifference: Int
    var title: String = ""
    var money: String = ""
    var content: String = ""
    var authImages: [UIImage] = []
    
    var isShowImagePicker: Bool = false
    
    var isAvailableRegister: Bool {
      return (Int(money) != nil) && ((5...15) ~= title.count) && ((3...100) ~= content.count) && authImages.isEmpty == false
    }
    
    init(challenge: Challenge, selectedDate: Date) {
      self.challenge = challenge
      self.selectedDate = selectedDate.toString(with: "M월 dd일")
      self.dateDifference = challenge.day(to: selectedDate)
    }
  }
  
  enum Action: Equatable {
    case showPicker(Bool)
    case titleChanged(String)
    case moneyChanged(String)
    case contentChanged(String)
    case imageAdd(UIImage)
    case imageRemove(UIImage)
    case registerRecord
    
    case _registerRecordResponse(TaskResult<Data>)
  }
  
  @Dependency(\.recordClient) var recordClient
  
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
      
    case .registerRecord:
      let images = state.authImages.compactMap { $0.pngData() }
      
      guard let userID = APIClient.currentUser?.userID else { return .none }
        
      let request = RecordRequest(
        challengeID: state.challenge.id,
        userID: userID,
        title: state.title,
        content: state.content,
        cost: state.money,
        images: images
      )
      return .run { send in
        await send(
          ._registerRecordResponse(
            TaskResult {
              try await recordClient.registerRecord(request)
            }
          )
        )
      }
      
    case ._registerRecordResponse(.success):
      return .none
    case ._registerRecordResponse(.failure):
      return .none
    }
  }
}
