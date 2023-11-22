//
//  NotificationClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Dependencies

struct Notification: Hashable, Decodable {
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
}

struct NotificationClient {
  var fetchUnreadNotification: @Sendable (_ userID: Int) async throws -> [Notification]
  var readNotification: @Sendable (_ notificationID: Int) async throws -> Data
}

extension NotificationClient: DependencyKey { }

extension DependencyValues {
  var notificationClient: NotificationClient {
    get { self[NotificationClient.self] }
    set { self[NotificationClient.self] = newValue }
  }
}
