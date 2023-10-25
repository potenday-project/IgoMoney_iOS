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
  }
}
