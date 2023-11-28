//
//  ChallengeClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Dependencies
import Foundation

extension ChallengeClient {
  static var liveValue = ChallengeClient {
    guard let user = APIClient.currentUser else {
      throw APIError.badRequest(400)
    }
    
    let api = ChallengeAPI(
      method: .get,
      path: "/challenges/my-active-challenge/\(user.userID.description)",
      query: [:],
      header: [:]
    )
    
    let response: Challenge = try await APIClient.request(to: api)
    return response
  } fetchNotStartedChallenge: { lastChallengeID, filterCategory in
    var lastID = 10
    var category = -1
    
    if let lastChallengeID = lastChallengeID {
      lastID += lastChallengeID
    }
    
    if let filterCategory = filterCategory {
      category = filterCategory
    }
    
    let api = ChallengeAPI(
      method: .get,
      path: "/challenges/notstarted",
      query: [
        "lastId": lastID.description,
        "pageSize": "\(10)",
        "categoryId": category.description
      ],
      header: [:]
    )
    let response: [Challenge] = try await APIClient.request(to: api)
    
    return response
  } enterChallenge: { challengeID in
    guard let userID = APIClient.currentUser?.userID.description else {
      throw APIError.badRequest(400)
    }
    
    let api = ChallengeAPI(
      method: .post,
      path: "/challenges/apply/\(challengeID)/\(userID)",
      query: [:],
      header: [:]
    )
    
    return try await APIClient.execute(to: api).isEmpty
  } generateChallenge: { challenge in
    let api = ChallengeAPI(
      method: .post,
      path: "/challenges/new",
      query: [:],
      header: [
        "Content-Type": "application/x-www-form-urlencoded"
      ],
      body: .urlEncoded(value: challenge.toDictionary())
    )
    
    let values: [String: Int] = try await APIClient.request(to: api)
    return values
  } challengeCosts: { challenge, isMine in
    guard let myID = APIClient.currentUser?.userID,
          let competitorID = challenge.competitorID else {
      throw APIError.badRequest(400)
    }
    
    let userID = isMine ? myID : competitorID
    
    let api = ChallengeAPI(
      method: .get,
      path: "/challenges/total-cost",
      query: [
        "challengeId": challenge.id.description,
        "userId": userID.description
      ],
      header: [:]
    )
    
    return try await APIClient.request(to: api)
  } giveUpChallenge: {
    guard let userID = APIClient.currentUser?.userID else {
      throw APIError.badRequest(400)
    }
    
    let api = ChallengeAPI(
      method: .post,
      path: "/challenges/giveup/\(userID)",
      query: [:],
      header: [:]
    )
    
    return try await APIClient.execute(to: api)
  }
}
