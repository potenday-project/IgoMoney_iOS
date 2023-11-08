//
//  RecordClient + Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

extension RecordClient {
  static var liveValue = RecordClient { request in
    let boundary = "Boundary_" + UUID().uuidString
    let api = RecordAPI(
      method: .post,
      path: "/records/new",
      query: [:],
      header: ["Content-Type": "multipart/form-data; boundary=\(boundary)"],
      body: .multipart(boundary: boundary, values: request.toDictionary())
    )
      
      print(api.body)
    
    return try await APIClient.execute(to: api)
  }
}
