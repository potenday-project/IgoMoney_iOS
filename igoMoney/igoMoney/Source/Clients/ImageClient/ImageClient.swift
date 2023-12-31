//
//  ImageClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import Dependencies

struct ImageClient {
  var getImageData: @Sendable (_ url: URL) async throws -> Data
}

extension ImageClient: DependencyKey { }

extension DependencyValues {
  var imageClient: ImageClient {
    get { self[ImageClient.self] }
    set { self[ImageClient.self] = newValue }
  }
}
