//
//  ImageClient + live.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

extension ImageClient {
  static var liveValue = ImageClient { url in
    let api = URLRequest(url: url)
    let response = try await APIClient.execute(to: api)
    return response
  } updateImageData: { data in
    guard let tokenInformation: AuthToken = try KeyChainClient.read(
      .token,
      SystemConfigConstants.tokenService
    ).toDecodable() else {
      throw APIError.badRequest(400)
    }
    
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
          "userId": .text(tokenInformation.userID.description),
          "image": .image(data)
        ]
      )
    )
    
    let response = try await APIClient.execute(to: api)
    return [:]
  }
}
