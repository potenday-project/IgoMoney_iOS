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
  } updateUserInformation: { nickName, imageData in
    guard let userID = APIClient.currentUser?.userID.description else {
      throw APIError.badRequest(400)
    }
    
    if let nickName = nickName {
      _ = try await Self.uploadUserNickName(to: userID, with: nickName)
    }
    
    if let imageData = imageData {
      _ = try await Self.uploadUserProfileImage(to: userID, with: imageData)
    }
    
    return true
  } getUserInformation: { userID in
    let fetchUserID = try Self.fetchUserID(to: userID)
    
    let api = AuthAPI(
      method: .get,
      path: "/users/\(fetchUserID)",
      query: [:],
      header: [:]
    )
    
    let response: User = try await APIClient.request(to: api)
    saveToken(with: response)
    
    return response
  }
  
  private static func fetchUserID(to userID: String?) throws -> String {
    guard let userID = userID else {
      let tokenData = try KeyChainClient.read(.token, SystemConfigConstants.tokenService)
      if let token: AuthToken = tokenData.toDecodable() {
        return token.userID.description
      }
      
      throw KeyChainClient.KeyChainError.itemNotFound
    }
    
    return userID
  }

  private static func saveToken(with response: User) {
    let tokenData = try? KeyChainClient.read(.token, SystemConfigConstants.tokenService)
    
    if let tokenInformation: AuthToken = tokenData?.toDecodable(),
        tokenInformation.userID == response.userID {
      APIClient.currentUser = response
    }
  }
}

private extension UserClient {
  static func uploadUserNickName(to userID: String, with nickName: String) async throws -> Data {
    let boundary = "Boundary_\(UUID().uuidString)"
    let api = AuthAPI(
      method: .patch,
      path: "/users/nickname",
      query: [:],
      header: [
        "Content-Type": "multipart/form-data; boundary=\(boundary)"
      ],
      body: .multipart(
        boundary: boundary,
        values: ["userId": .text(userID), "nickname": .text(nickName)]
      )
    )
    
    return try await APIClient.execute(to: api)
  }
  
  static func uploadUserProfileImage(to userID: String, with imageData: Data) async throws -> Data {
    let boundary = "Boundary_\(UUID().uuidString)"
    
    let api = ImageLoadAPI(
      method: .patch,
      path: "/users/profile-image",
      header: [
        "Content-Type": "multipart/form-data; boundary=\(boundary)"
      ],
      body: .multipart(
        boundary: boundary,
        values: [
          "userId": .text(userID),
          "image": .image(imageData)
        ]
      )
    )
    
    return try await APIClient.execute(to: api)
  }
}
