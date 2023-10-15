//
//  GenerateRoomCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct GenerateRoomCore: Reducer {
  struct State: Equatable {
    var targetAmount: TargetMoneyAmount = .init(money: 10000)
    var selectionCategory: ChallengeCategory = .living
    var startDate: Date? = nil
    
    var title: String = ""
    var content: String = ""
    
    var endDate: Date {
      return calculateEndDate() ?? Date()
    }
    
    var isFillTitle: Bool {
      return (5...15) ~= title.count
    }
    
    var isFillContent: Bool {
      return content.count <= 50 && content.count != .zero
    }
    
    var isSendable: Bool {
      return isFillTitle && isFillContent && startDate != nil
    }
    
    var showAlert: Bool = false
  }
  
  enum Action: Equatable {
    case selectTargetAmount(TargetMoneyAmount)
    case selectCategory(ChallengeCategory)
    case selectDate(Date)
    case didChangeTitle(String)
    case didChangeContent(String)
    case didEnterChallenge
    
    case _enterChallengeResponse(TaskResult<[String: Int]>)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .selectTargetAmount(let amount):
      state.targetAmount = amount
      return .none
      
    case .selectCategory(let category):
      state.selectionCategory = category
      return .none
      
    case .selectDate(let selectedDate):
      state.startDate = selectedDate
      return .none
      
    case .didChangeTitle(let title):
      if title.count > 15 { return .none }
      state.title = title
      return .none
      
    case .didChangeContent(let content):
      if content.count > 50 { return .none }
      state.content = content
      return .none
      
    case .didEnterChallenge:
      guard let userID = APIClient.currentUser?.userID else {
        return .none
      }
      
      guard let startDate = state.startDate?.toString(with: "yyyy-MM-dd") else {
        return .none
      }
      
      let request = ChallengeGenerateRequest(
        userID: userID,
        title: state.title,
        content: state.content,
        targetAmount: state.targetAmount.money,
        categoryID: state.selectionCategory.rawValue,
        startDate: startDate
      )
      
      return .run { send in
        await send(
          ._enterChallengeResponse(
            TaskResult {
              try await challengeClient.generateChallenge(request)
            }
          )
        )
      }
    default:
      return .none
    }
  }
}

extension GenerateRoomCore.State {
  func calculateEndDate() -> Date? {
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "ko-KR")
    guard let startDate = startDate else { return nil }
    return calendar.date(byAdding: .day, value: 7, to: startDate) ?? startDate
  }
}
