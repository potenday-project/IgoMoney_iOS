//
//  UserClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

extension UserClient {
  static var liveValue = UserClient { nickName in
    let api = AuthAPI(
      method: .get,
      path: "/users/nickname/\(nickName)",
      query: [:],
      header: [:]
    )
    return try await APIClient.execute(to: api).isEmpty
  } updateUserInformation: { userID, nickName in
    let boundary = "Boundary_\(UUID().uuidString)"
    let api = AuthAPI(
      method: .patch,
      path: "/users",
      query: [:],
      header: [
        "Content-Type": "multipart/form-data; boundary=\(boundary)"
      ],
      body: .multipart(
        boundary: boundary,
        values: ["id": userID, "nickname": nickName]
      )
    )
    
    return try await APIClient.execute(to: api).isEmpty
  } getUserInformation: { userID in
    let api = AuthAPI(
      method: .get,
      path: "/users/\(userID)",
      query: [:],
      header: [:]
    )
    
    let response: User = try await APIClient.request(to: api)
    saveToken(with: response)
    
    return response
  }

  private static func saveToken(with response: User) {
    let tokenData = try? KeyChainClient.read(.token, SystemConfigConstants.tokenService)
    
    if let tokenInformation: AuthToken = tokenData?.toDecodable(),
        tokenInformation.userID == response.userID {
      APIClient.currentUser = response
    }
  }
}


//  {
//
//    return Self {
//      guard let user = APIClient.currentUser else {
//        throw APIError.badRequest(400)
//      }
//
//      let requestGenerator = ChallengeAPI(
//        method: .get,
//        path: "/challenges/my-active-challenge/\(user.userID.description)",
//        query: [:],
//        header: [:]
//      )
//
//      let response: Challenge = try await APIClient.request(to: requestGenerator)
//      return response
//    } fetchNotStartedChallenge: {
//      let requestGenerator = ChallengeAPI(
//        method: .get,
//        path: "/challenges/notstarted",
//        query: [:],
//        header: [:]
//      )
//
//      let response: [Challenge] = try await APIClient.request(to: requestGenerator)
//      return response
//    } enterChallenge: { challengeID in
//      guard let userID = APIClient.currentUser else {
//        throw APIError.badRequest(400)
//      }
//
//      let requestGenerator = ChallengeAPI(
//        method: .post,
//        path: "/challenges/apply/\(challengeID)/\(userID.userID.description)",
//        query: [:],
//        header: [:]
//      )
//
//      let data = try await APIClient.execute(to: requestGenerator)
//      return true
//    } generateChallenge: { request in
//      let requestGenerator = ChallengeAPI(
//        method: .post,
//        path: "/challenges/new",
//        query: [:],
//        header: [
//          "Content-Type": "application/x-www-form-urlencoded"
//        ],
//        body: .urlEncoded(value: request.toDictionary())
//      )
//
//      let values: [String: Int] = try await APIClient.request(to: requestGenerator)
//      return values
//    }
//  }()
//}
