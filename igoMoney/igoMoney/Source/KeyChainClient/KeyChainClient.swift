//
//  KeyChainClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Security

import Dependencies

enum ServiceKeys: NSString {
  case token
  case userIdentifier
}

protocol KeyChain {
  @Sendable func save(_ data: Data, _ services: ServiceKeys, _ account: String) async throws
  @Sendable func update(_ data: Data, _ services: ServiceKeys, _ account: String) async throws
  @Sendable func delete(_ services: ServiceKeys, _ account: String) async throws
  @Sendable func read(_ service: ServiceKeys, _ account: String) async throws -> Data
}

struct KeyChainClient: KeyChain {
  enum KeyChainError: Error {
    case itemNotFound
    case duplicatedItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)
    case errorStatus(String?)
    
    init(status: OSStatus) {
      switch status {
      case errSecItemNotFound:
        self = .itemNotFound
      case errSecDuplicateItem:
        self = .duplicatedItem
      default:
        let message = SecCopyErrorMessageString(status, nil) as String?
        self = .errorStatus(message)
      }
    }
  }
  
  static func generateQuery(serviceKey: NSString, account: String) -> [String: Any] {
    return [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceKey,
      kSecAttrAccount as String: account
    ] as [String: Any]
  }
  
  func save(_ data: Data, _ services: ServiceKeys, _ account: String) async throws {
    var query = Self.generateQuery(serviceKey: services.rawValue, account: account)
    query[kSecValueData as String] = data
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status == errSecDuplicateItem {
      try await update(data, services, account)
      return
    }
    
    guard status == errSecSuccess else {
      throw KeyChainError(status: status)
    }
  }
  
  func update(_ data: Data, _ services: ServiceKeys, _ account: String) async throws {
    let query = Self.generateQuery(serviceKey: services.rawValue, account: account)
    
    let attributes: [String: Any] = [
      kSecValueData as String: data
    ]
    
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    
    guard status != errSecItemNotFound else {
      throw KeyChainError(status: status)
    }
    
    guard status == errSecSuccess else {
      throw KeyChainError.unexpectedStatus(status)
    }
  }
  
  func delete(_ services: ServiceKeys, _ account: String) async throws {
    let query = Self.generateQuery(serviceKey: services.rawValue, account: account)
    
    let status = SecItemDelete(query as CFDictionary)
    
    guard status == errSecSuccess else {
      throw KeyChainError.unexpectedStatus(status)
    }
  }
  
  func read(_ service: ServiceKeys, _ account: String) throws -> Data {
    var query = Self.generateQuery(serviceKey: service.rawValue, account: account)
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    query[kSecReturnData as String] = true
    query[kSecReturnAttributes as String] = true
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    guard status != errSecItemNotFound else {
      throw KeyChainError.itemNotFound
    }
    
    guard status == errSecSuccess else {
      throw KeyChainError.unexpectedStatus(status)
    }
    
    guard let value = item?[kSecValueData] as? Data else {
      throw KeyChainError.invalidItemFormat
    }
    
    return value
  }
}

private enum KeychainClientKey: DependencyKey {
  static let liveValue = KeyChainClient()
}

extension DependencyValues {
  var keyChainClient: KeyChainClient {
    get { self[KeychainClientKey.self] }
    set { self[KeychainClientKey.self] = newValue }
  }
}
