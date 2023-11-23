//
//  NotificationClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import ComposableArchitecture

extension NotificationClient {
  static var liveValue: NotificationClient = .init {
    guard let userID = APIClient.currentUser?.userID else {
      throw APIError.badRequest(400)
    }
    
    let api = NotificationAPI(
      method: .get,
      path: "/users/notification/\(userID)/",
      query: [:],
      header: [:]
    )
    
    let response: [Notification] = try await APIClient.request(to: api)
    
    return response
  } readNotification: { notificationID in
    let api = NotificationAPI(
      method: .post,
      path: "/users/notification/check/\(notificationID)/",
      query: [:],
      header: [:]
    )
    
    return try await APIClient.execute(to: api)
  }
}
