//
//  NotificationCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

struct NotificationCore: Reducer {
  struct State: Equatable {
    var unreadNotifications: [Notification] = []
  }
  
  enum Action: Equatable {
    case onAppear
    case _fetchUnreadNotification
    case _fetchUnreadNotificationResponse(TaskResult<[Notification]>)
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
      return .none
      
    case ._fetchUnreadNotificationResponse(.failure):
      state.unreadNotifications = []
      return .none
    }
  }
}
