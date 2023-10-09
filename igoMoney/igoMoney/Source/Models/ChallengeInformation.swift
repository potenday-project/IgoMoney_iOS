//
//  ChallengeInformation.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct Challenge: Decodable, Equatable, Identifiable {
  let id: Int
  let recordID: Int?
  let leaderID: Int
  let competitorID: Int?
  let winnerID: Int?
  let title: String
  let content: String
  let targetAmount: TargetMoneyAmount
  let startDate: Date?
  let term: Int?
  let endDate: Date?
  
  var isStart: Bool {
    if let startDate = startDate {
      return startDate <= Date()
    }
    
    return false
  }
  
  var userDescription: String {
    return isStart ? "\(id)님과 챌린지 진행 중" : "\(id)님과 챌린지"
  }
  
  enum CodingKeys: String, CodingKey {
    case recordID = "recordId"
    case id = "id"
    case leaderID = "leaderId"
    case competitorID = "competitorId"
    case winnerID = "winnerId"
    case title, content, targetAmount, startDate, term, endDate
  }
}

extension Challenge {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    recordID = try? container.decode(Int.self, forKey: .recordID)
    leaderID = try container.decode(Int.self, forKey: .leaderID)
    competitorID = try? container.decode(Int.self, forKey: .competitorID)
    winnerID = try? container.decode(Int.self, forKey: .winnerID)
    title = try container.decode(String.self, forKey: .title)
    content = try container.decode(String.self, forKey: .content)
    let moneyValue = try container.decode(Int.self, forKey: .targetAmount)
    targetAmount = TargetMoneyAmount(money: moneyValue)
    term = try? container.decode(Int.self, forKey: .term)
    startDate = try? container.decode(Date.self, forKey: .startDate)
    endDate = try? container.decode(Date.self, forKey: .endDate)
  }
  
  static let `default`: Challenge = .init(
    id: 3,
    recordID: nil,
    leaderID: 2,
    competitorID: nil,
    winnerID: nil,
    title: "만원의 행복 도전해봐요! 만원의 행복 도전해봐요! 만원의 행복 도전해봐요! 만원의 행복 도전해봐요!",
    content: "오늘부터 일주일 동안 만원으로 대결하실 분 구합니다. 최대한 커피 지출을 줄이고 싶습니다.",
    targetAmount: .init(money: 30000),
    startDate: nil,
    term: nil,
    endDate: nil
  )
}

struct TargetMoneyAmount: Decodable, CustomStringConvertible, Equatable {
  let money: Int
  
  var description: String {
    return "\(money / 10000)만원"
  }
  
  var colorName: String {
    switch money {
    case 10000..<20000:
      return "yellow"
    case 20000..<30000:
      return "orange"
    case 30000..<40000:
      return "blue"
    case 40000..<50000:
      return "red"
    case 50000...:
      return "purple"
      
    default:
      return "yellow"
    }
  }
}

struct User: Decodable, Equatable {
  let userID: Int
  let provider: Provider?
  let email: String
  let nickName: String?
  let profileImagePath: String?
  let role: String
  
  enum CodingKeys: String, CodingKey {
    case userID = "id"
    case provider = "provider"
    case email = "email"
    case nickName = "nickname"
    case profileImagePath = "image"
    case role = "role"
  }
  
  static let `default` = User(
    userID: 2,
    provider: nil,
    email: "dlrudals8899@gmail.com",
    nickName: nil,
    profileImagePath: nil,
    role: "ROLE_USER"
  )
}

extension User {
  init(userID: Int) {
    self.userID = userID
    self.provider = nil
    self.email = ""
    self.nickName = nil
    self.profileImagePath = nil
    self.role = "ROLE_USER"
  }
}
