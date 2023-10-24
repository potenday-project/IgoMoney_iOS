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
  } updateImageData: { nickName, data in
    guard let tokenInformation: AuthToken = try KeyChainClient.read(
      .token,
      SystemConfigConstants.tokenService
    ).toDecodable() else {
      throw APIError.badRequest(400)
    }
    
    let boundary = "Boundary_\(UUID().uuidString)"
    
    let api = ImageLoadAPI(
      method: .patch,
      path: "/users",
      header: [
        "Content-Type": "multipart/form-data; boundary=\(boundary)"
      ],
      body: .multipart(
        boundary: boundary,
        values: [
          "id": .text(tokenInformation.userID.description),
          "nickname": .text(nickName),
          "image": .image(data),
          "imageChanged": .text("1")
        ]
      )
    )
    
    let response: [String: String] = try await APIClient.request(to: api)
    return response
  }
}
