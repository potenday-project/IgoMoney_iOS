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

class KeyChainClient {
  static let serviceName = "igomoneyService"
  static let account = "com.app.igomoney"
  
  static var currentUserIdentifier: String {
    return KeyChainClient.readIdentifier()
  }
  
  @discardableResult
  static func saveIdentifier(identifier: String) -> Bool {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: "userIdentifier",
      kSecValueData as String: identifier.data(using: .utf8)!
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    return status == errSecSuccess
  }
  
  @discardableResult
  static func create(authToken: AuthToken) -> Bool {
    guard let tokenData = try? JSONEncoder().encode(authToken) else {
      return false
    }
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: account,
      kSecValueData as String: tokenData
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status == errSecDuplicateItem {
      return update(authToken: authToken)
    }
    
    return status == errSecSuccess
  }
  
  @discardableResult
  static func read() -> AuthToken? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: account,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnData as String: true,
      kSecReturnAttributes as String: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    guard status != errSecItemNotFound else {
      return nil
    }
    
    guard status == errSecSuccess else {
      return nil
    }
    
    guard let existingItem = item as? [String: Any],
          let tokenData = existingItem[kSecValueData as String] as? Data,
          let decodeToken = try? JSONDecoder().decode(AuthToken.self, from: tokenData) else {
      return nil
    }
    
    return decodeToken
  }
  
  @discardableResult
  static func readIdentifier() -> String {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: "userIdentifier",
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnData as String: true,
      kSecReturnAttributes as String: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    guard status != errSecItemNotFound else {
      return ""
    }
    
    guard status == errSecSuccess else {
      return ""
    }
    
    guard let existingItem = item as? [String: Any],
          let identifierData = existingItem[kSecValueData as String] as? Data,
          let decodeToken = String(data: identifierData, encoding: .utf8) else {
      return ""
    }
    
    return decodeToken
  }
  
  @discardableResult
  static func update(authToken: AuthToken) -> Bool {
    guard let tokenData = try? JSONEncoder().encode(authToken) else {
      return false
    }
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword
    ]
    
    let attributes: [String: Any] = [
      kSecAttrService as String: serviceName,
      kSecAttrAccount as String: account,
      kSecValueData as String: tokenData
    ]
    
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    
    guard status != errSecItemNotFound else {
      return false
    }
    
    return status == errSecSuccess
  }
  
  static func read(isFail: Bool) -> AuthToken? {
    if isFail {
      return .failureDefault
    } else {
      return .successDefault
    }
  }
}

//extension KeyChainClient: DependencyKey {
//  static var liveValue: KeyChainClient {
//    return Self
//  }
//}
