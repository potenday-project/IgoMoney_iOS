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
  let category: ChallengeCategory?
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
    case category = "categoryId"
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
    category = try? container.decode(ChallengeCategory.self, forKey: .category)
    term = try? container.decode(Int.self, forKey: .term)
    let startDateString = try? container.decode(String.self, forKey: .startDate)
    startDate = startDateString?.toDate(with: "yyyy-MM-dd")
    let endDateString = try? container.decode(String.self, forKey: .endDate)
    endDate = endDateString?.toDate(with: "yyyy-MM-dd")
  }
  
  static let `default`: Challenge = .init(
    id: 1,
    recordID: nil,
    leaderID: 2,
    competitorID: 2,
    winnerID: nil,
    title: "만원의 행복🥇",
    content: "이번엔진짜해본다",
    targetAmount: .init(money: 10000),
    category: .living,
    startDate: "2023-10-29".toDate(with: "yyyy-MM-dd"),
    term: 7,
    endDate: nil
  )
  
  func day(to selectedDate: Date) -> Int {
    guard let startDate = startDate else { return .zero }
    let difference = Calendar.current.dateComponents([.day], from: startDate, to: selectedDate).day
    return (difference ?? .zero) + 1
  }
}

enum ChallengeCategory: Int, Decodable, CustomStringConvertible, CaseIterable {
  case living = 1
  case food
  case traffic
  case shopping
  case hobby
  
  var description: String {
    switch self {
    case .living:
      return "생활비"
    case .food:
      return "식비"
    case .traffic:
      return "교통비"
    case .shopping:
      return "쇼핑"
    case .hobby:
      return "취미"
    }
  }
  
  var emoji: String {
    switch self {
    case .living:
      return "💸"
    case .food:
      return "🍽"
    case .traffic:
      return "🚇"
    case .shopping:
      return "🛍"
    case .hobby:
      return "🎬"
    }
  }
}

struct TargetMoneyAmount: Decodable, CustomStringConvertible, Equatable, CaseIterable {
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
  
  static var allCases: [TargetMoneyAmount] = [
    .init(money: 10000),
    .init(money: 20000),
    .init(money: 30000),
    .init(money: 40000),
    .init(money: 50000),
  ]
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
