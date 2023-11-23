//
//  NotificationCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct NotificationCore: Reducer {
  struct State: Equatable {
    var unreadNotifications: [Notification] = [.default, .default]
  }
  
  enum Action: Equatable {
    case onAppear
    case _fetchUnreadNotification
    case _fetchUnreadNotificationResponse(TaskResult<[Notification]>)
    case _readNotification
    case _readNotificationResponse(TaskResult<[Data]>)
  }
  
  @Dependency(\.notificationClient) var notificationClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(._fetchUnreadNotification)
      
    case ._fetchUnreadNotification:
      return .run { send in
        await send(
          ._fetchUnreadNotificationResponse(
            TaskResult {
              try await notificationClient.fetchUnreadNotification()
            }
          )
        )
      }
    case ._fetchUnreadNotificationResponse(.success(let notifications)):
      state.unreadNotifications = notifications
      return .send(._readNotification)
      
    case ._fetchUnreadNotificationResponse(.failure):
      state.unreadNotifications = []
      return .none
      
    case ._readNotification:
      let notifications = state.unreadNotifications
      
      if notifications.isEmpty { return .none }
      
      return .run { send in
        await send(
          ._readNotificationResponse(
            TaskResult {
              try await notificationClient.readNotifications(notifications)
            }
          )
        )
      }
      
    case ._readNotificationResponse(.success):
      return .none
    case ._readNotificationResponse(.failure):
      return .none
    }
  }
}
