//
//  KeyChainClient.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Security

import Dependencies

//struct KeyChainClient {
//  var saveIdentifier: @Sendable (_ identifier: String) -> Bool
//  var saveToken: @Sendable (_ token: AuthToken) -> Bool
//  var readIdentifier: @Sendable () -> String
//  var readToken: @Sendable () -> AuthToken?
//}

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
  
  func save(_ data: Data, _ services: ServiceKeys, _ account: String) async throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: services.rawValue,
      kSecAttrAccount as String: account,
      kSecValueData as String: data
    ]
    
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
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: services.rawValue,
      kSecAttrAccount as String: account,
    ]
    
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
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: services.rawValue,
      kSecAttrAccount as String: account
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    guard status == errSecSuccess else {
      throw KeyChainError.unexpectedStatus(status)
    }
  }
  
  func read(_ service: ServiceKeys, _ account: String) async throws -> Data {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service.rawValue,
      kSecAttrAccount as String: account,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnData as String: true,
      kSecReturnAttributes as String: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    guard status != errSecItemNotFound else {
      throw KeyChainError.itemNotFound
    }
    
    guard status == errSecSuccess else {
      throw KeyChainError.unexpectedStatus(status)
    }
    
    guard let value = item as? Data else {
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
