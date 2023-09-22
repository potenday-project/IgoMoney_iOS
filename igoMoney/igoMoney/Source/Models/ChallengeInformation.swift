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
  let targetAmount: Int
  let user: User
  
  static let `default`: [Self] = Array(
    repeating: ChallengeInformation(
      id: UUID(),
      title: "일주일에 3만원으로 살아남기 👊🏻",
      content: "",
      targetAmount: 30000,
      user: .default
    ),
    count: 3
  )
  
  
  static func == (lhs: ChallengeInformation, rhs: ChallengeInformation) -> Bool {
    return lhs.id == rhs.id
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
