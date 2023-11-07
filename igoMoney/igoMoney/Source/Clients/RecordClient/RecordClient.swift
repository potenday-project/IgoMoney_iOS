//
//  RecordClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

struct RecordRequest: Codable, Sendable {
  let challengeID: Int
  let userID: Int
  let title: String
  let content: String
  let cost: String
  let image: Data
  
  func toDictionary() -> [String: MultipartForm.FormData] {
    return [
      "challengeId": .text(challengeID.description),
      "userId": .text(userID.description),
      "title": .text(title),
      "content": .text(content),
      "cost": .text(cost),
      "image": .image(image)
    ]
  }
}

struct RecordClient {
  var registerRecord: @Sendable (RecordRequest) async throws -> Data
}

extension RecordClient: DependencyKey { }

extension DependencyValues {
  var recordClient: RecordClient {
    get { self[RecordClient.self] }
    set { self[RecordClient.self] = newValue }
  }
}
