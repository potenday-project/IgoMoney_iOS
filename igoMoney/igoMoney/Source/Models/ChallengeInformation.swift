//
//  ChallengeInformation.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct Challenge: Decodable {
  let recordID: Int
  let userID: Int
  let leaderID: Int
  let winnerID: Int?
  let title: String
  let content: String
  let targetAmount: TargetMoneyAmount
  let startDate: Date?
  let term: Int
  let endDate: Date?
  
  enum CodingKeys: String, CodingKey {
    case recordID = "recordId"
    case userID = "id"
    case leaderID = "leaderId"
    case winnerID = "winnerId"
    case title, content, targetAmount, startDate, term, endDate
  }
}

extension Challenge {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    recordID = try container.decode(Int.self, forKey: .recordID)
    userID = try container.decode(Int.self, forKey: .userID)
    leaderID = try container.decode(Int.self, forKey: .leaderID)
    winnerID = try? container.decode(Int.self, forKey: .winnerID)
    title = try container.decode(String.self, forKey: .title)
    content = try container.decode(String.self, forKey: .content)
    targetAmount = try container.decode(TargetMoneyAmount.self, forKey: .targetAmount)
    term = try container.decode(Int.self, forKey: .term)
    startDate = try? container.decode(Date.self, forKey: .startDate)
    endDate = try? container.decode(Date.self, forKey: .endDate)
  }
}

struct ChallengeInformation: Decodable, Equatable, Identifiable {
  var id = UUID()
  
  let title: String
  let content: String
  let targetAmount: TargetMoneyAmount
  var startDate: Date? = nil
  let user: User
  
  var challengeDateRange: [Date] {
    guard let startDate = startDate else { return Array(repeating: Date(), count: 7) }
    var dates = [Date]()
    for index in 0..<7 {
      let interval = Double(index * 86400)
      dates.append(startDate.addingTimeInterval(interval))
    }
    return dates
  }
  
  static let `default`: [Self] = [
    ChallengeInformation(
      title: "일주일에 3만원으로 살아남기 👊🏻",
      content: "",
      targetAmount: .init(money: 10000),
      user: .default
    ),
    ChallengeInformation(
      title: "일주일에 3만원으로 살아남기 👊🏻",
      content: "",
      targetAmount: .init(money: 20000),
      user: .default
    ),
    ChallengeInformation(
      title: "일주일에 3만원으로 살아남기 👊🏻",
      content: "",
      targetAmount: .init(money: 30000),
      user: .default
    ),
    ChallengeInformation(
      title: "일주일에 3만원으로 살아남기 👊🏻",
      content: "",
      targetAmount: .init(money: 40000),
      user: .default
    ),
    ChallengeInformation(
      title: "일주일에 3만원으로 살아남기 👊🏻",
      content: "",
      targetAmount: .init(money: 50000),
      user: .default
    )
  ]
  
  static func == (lhs: ChallengeInformation, rhs: ChallengeInformation) -> Bool {
    return lhs.id == rhs.id
  }
}

struct TargetMoneyAmount: Decodable, CustomStringConvertible, Equatable {
  var id = UUID()
  let money: Int
  
  var description: String {
    return "💸 \(money)원"
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
