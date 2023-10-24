//
//  ImageClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

struct ImageClient {
  var getImageData: @Sendable (_ url: URL) async throws -> Data
  var updateImageData: @Sendable (_ nickName: String, _ data: Data) async throws -> [String: String]
}

extension ImageClient: DependencyKey { }

extension DependencyValues {
  var imageClient: ImageClient {
    get { self[ImageClient.self] }
    set { self[ImageClient.self] = newValue }
  }
}
