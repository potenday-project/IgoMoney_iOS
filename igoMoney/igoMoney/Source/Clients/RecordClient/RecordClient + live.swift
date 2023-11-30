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
    
    return try await APIClient.execute(to: api)
  } fetchAllRecord: { selectedDate, userID in
    let api = RecordAPI(
      method: .get,
      path: "/records/daily-records/\(userID)/\(selectedDate.toString(with: "yyyy-MM-dd"))",
      query: [:],
      header: [:]
    )
    
    return try await APIClient.request(to: api)
  } updateRecord: { request in
    let boundary = "Boundary_\(UUID().uuidString)"
    let api = RecordAPI(
      method: .patch,
      path: "/records/edit",
      query: [:],
      header: ["Content-Type": "multipart/form-data; boundary=\(boundary)"],
      body: .multipart(boundary: boundary, values: request.toUpdateRequest())
    )
    
    let response = try await APIClient.execute(to: api)
    return response
  } fetchRecord: { recordID in
    let api = RecordAPI(
      method: .get,
      path: "/records/\(recordID)",
      query: [:],
      header: [:]
    )
    
    return try await APIClient.request(to: api)
  } deleteRecord: { recordID in
    let api = RecordAPI(
      method: .delete,
      path: "/records/delete/\(recordID)",
      query: [:],
      header: [:]
    )
    
    return try await APIClient.execute(to: api)
  } reportRecord: { record, reason in
    guard let userID = APIClient.currentUser?.userID else {
      throw APIError.badRequest(400)
    }
    
    let boundary = "Boundary_" + UUID().uuidString
    
    let api = RecordAPI(
      method: .post,
      path: "/records/report",
      query: [:],
      header: [
        "Content-Type": "multipart/form-data; boundary=\(boundary)"
      ],
      body: .multipart(
        boundary: boundary,
        values: [
          .init(key: "recordId"): .text(record.ID.description),
          .init(key: "reporter_userId"): .text(userID.description),
          .init(key: "offender_userId"): .text(record.userID.description),
          .init(key: "reason"): .text(reason.description)
        ]
      )
    )
    
    return try await APIClient.execute(to: api)
  }
}
