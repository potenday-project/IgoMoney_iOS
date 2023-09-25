//
//  ChallengeInformation.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

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
  let id: String
  let nickName: String
  let profileImagePath: String?
  let email: String
  
  static let `default` = User(
    id: UUID().uuidString,
    nickName: "아이고머니",
    profileImagePath: nil,
    email: "cow970814@naver.com"
  )
}
