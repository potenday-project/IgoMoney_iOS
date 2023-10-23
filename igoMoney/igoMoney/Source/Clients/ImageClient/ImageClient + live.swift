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
    let api = ImageLoadAPI(
      method: .post,
      path: "/users",
      body: .multipart(
        boundary: UUID().uuidString,
        values: ["profile": .image(data)]
      )
    )
    
    let response: [String: String] = try await APIClient.request(to: api)
    return response
  }
}
