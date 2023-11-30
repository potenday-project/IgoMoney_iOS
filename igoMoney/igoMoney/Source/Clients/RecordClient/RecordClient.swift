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
  let images: [Data]
  
  func toDictionary() -> [MultipartForm.FormKey: MultipartForm.FormData] {
    var postValues: [MultipartForm.FormKey: MultipartForm.FormData] = [
      .init(key:"challengeId"): .text(challengeID.description),
      .init(key:"userId"): .text(userID.description),
      .init(key:"title"): .text(title),
      .init(key:"content"): .text(content),
      .init(key:"cost"): .text(cost)
    ]
    
    images.forEach {
      postValues[.init(key: "image[]")] = .image($0)
    }
    
    return postValues
  }
  
  func toUpdateRequest() -> [MultipartForm.FormKey: MultipartForm.FormData] {
    var updateValues: [MultipartForm.FormKey: MultipartForm.FormData] = [
      .init(key:"recordId"): .text(challengeID.description),
      .init(key:"title"): .text(title),
      .init(key:"content"): .text(content),
      .init(key:"cost"): .text(cost)
    ]
    
    images.forEach {
      updateValues[.init(key: "image[]")] = .image($0)
    }
    
    return updateValues
  }
}

struct ChallengeRecord: Decodable, Equatable {
  let ID: Int
  let challengeID: Int
  let userID: Int
  let title: String
  let content: String
  let imagePath: [String]
  let cost: Int
  let date: Date
  let isHide: Bool
  
  var dateDescription: String {
    return date.toString(with: "MM월 dd일")
  }
  
  enum CodingKeys: String, CodingKey {
    case ID = "recordId"
    case challengeID = "challengeId"
    case userID = "userId"
    case title
    case content
    case imagePath = "image"
    case cost
    case date
    case isHide = "hide"
  }
  
  init(
    ID: Int,
    challengeID: Int,
    userID: Int,
    title: String,
    content: String,
    imagePath: [String],
    cost: Int,
    date: Date,
    isHide: Bool
  ) {
    self.ID = ID
    self.challengeID = challengeID
    self.userID = userID
    self.title = title
    self.content = content
    self.imagePath = imagePath
    self.cost = cost
    self.date = date
    self.isHide = isHide
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.ID = try container.decode(Int.self, forKey: .ID)
    self.challengeID = try container.decode(Int.self, forKey: .challengeID)
    self.userID = try container.decode(Int.self, forKey: .userID)
    self.title = try container.decode(String.self, forKey: .title)
    self.content = try container.decode(String.self, forKey: .content)
    self.imagePath = try container.decode([String].self, forKey: .imagePath)
    self.cost = try container.decode(Int.self, forKey: .cost)
    let stringDate = try container.decode(String.self, forKey: .date)
    self.date = stringDate.toDate(with: "yy.MM.dd") ?? Date()
    self.isHide = try container.decode(Bool.self, forKey: .isHide)
  }
  
  static let `default` = Self.init(
    ID: 1,
    challengeID: 1,
    userID: 1,
    title: "123123123123123123",
    content: "123123123123123123123",
    imagePath: [""],
    cost: 200,
    date: Date(),
    isHide: false
  )
}

struct RecordClient {
  var registerRecord: @Sendable (RecordRequest) async throws -> Data
  var fetchAllRecord: @Sendable (_ selectedDate: Date, _ userID: Int) async throws -> [ChallengeRecord]
  var updateRecord: @Sendable (RecordRequest) async throws -> Data
  var fetchRecord: @Sendable (_ recordID: Int) async throws -> ChallengeRecord
  var deleteRecord: @Sendable (_ recordID: Int) async throws -> Data
  var reportRecord: @Sendable (_ record: ChallengeRecord, _ reason: Int) async throws -> Data
}

extension RecordClient: DependencyKey { }

extension DependencyValues {
  var recordClient: RecordClient {
    get { self[RecordClient.self] }
    set { self[RecordClient.self] = newValue }
  }
}
