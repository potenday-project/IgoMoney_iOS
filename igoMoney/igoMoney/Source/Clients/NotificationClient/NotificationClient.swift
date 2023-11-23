//
//  NotificationClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Dependencies

struct Notification: Hashable, Decodable, Equatable {
  let ID: Int
  let userID: Int
  let title: String
  let content: String
  
  enum CodingKeys: String, CodingKey {
    case ID = "notificationId"
    case userID = "userId"
    case title = "title"
    case content = "message"
  }
  
  static let `default` = Notification(
    ID: 1,
    userID: 1,
    title: "챌린지 결과",
    content: "아이고머니님! 뒷주머니님과의 챌린지 대결에서 승리하셔서 뱃지를 획득하셨습니다. 새로운 챌린지에 도전해보세요."
  )
}

struct NotificationClient {
  var fetchUnreadNotification: @Sendable () async throws -> [Notification]
  var readNotification: @Sendable (_ notificationID: Int) async throws -> Data
}

extension NotificationClient: DependencyKey { }

extension DependencyValues {
  var notificationClient: NotificationClient {
    get { self[NotificationClient.self] }
    set { self[NotificationClient.self] = newValue }
  }
}
