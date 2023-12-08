//
//  NoticeClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import ComposableArchitecture

import Dependencies

extension NoticeClient {
  static var liveValue: NoticeClient = NoticeClient(fetchAllNotice: { lastID in
    let api = NoticeAPI(
      method: .get,
      path: "/news",
      query: ["lastId": lastID.description],
      header: [:]
    )
    
    return try await APIClient.request(to: api)
  })
}
