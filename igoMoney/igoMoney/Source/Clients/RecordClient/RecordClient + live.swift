//
//  RecordClient + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

extension RecordClient {
  static var liveValue = RecordClient { request in
    let boundary = UUID().uuidString
    let api = RecordAPI(
      method: .post,
      path: "/records/new",
      query: [:],
      header: [:],
      body: .multipart(boundary: boundary, values: request.toDictionary())
    )
    
    return try await APIClient.execute(to: api)
  }
}
