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
    
    var alertState: IGOAlertCore.State = .init()
    var alertTitle: String = ""
  }
  
  enum Action: Equatable {
    case selectTargetAmount(TargetMoneyAmount)
    case selectCategory(ChallengeCategory)
    case selectDate(Date)
    case didChangeTitle(String)
    case didChangeContent(String)
    case didEnterChallenge
    
    case _enterChallengeResponse(TaskResult<[String: Int]>)
    
    case alertAction(IGOAlertCore.Action)
  }
  
  @Dependency(\.challengeClient) var challengeClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.alertState, action: /Action.alertAction) {
      IGOAlertCore()
    }
    
    Reduce { state, action in
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
        
      case ._enterChallengeResponse(.success):
        state.alertTitle = "챌린지가 만들어졌어요!\n상대를 기다려봐요."
        return .send(.alertAction(.present))
        
      case ._enterChallengeResponse(.failure(let error)):
        if case let .badRequest(statusCode) = error as? APIError {
          if statusCode == 409 {
            state.alertTitle = "이미 참가 중인 챌린지가 존재합니다."
            return .send(.alertAction(.present))
          }
        }
        
        state.alertTitle = "오류가 발생하였습니다.\n 잠시 후 다시 시도해주세요."
        return .send(.alertAction(.present))
        
      default:
        return .none
      }
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
