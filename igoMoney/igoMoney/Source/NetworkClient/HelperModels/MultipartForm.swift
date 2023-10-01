//
//  MultipartForm.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct MultipartForm {
  let boundary: String
  var values: [String: String]
}

extension MultipartForm {
  func httpBody() -> Data {
    var data = Data()
    
    values.forEach { (key, value) in
      guard let boundaryData = "--\(boundary)\r\n".data(using: .utf8),
            let contentType = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8),
            let contentData = (value + "\r\n").data(using: .utf8) else {
        return
      }
      
      data.append(boundaryData)
      data.append(contentType)
      data.append(contentData)
    }
    
    guard let endData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else {
      return Data()
    }
    data.append(endData)
    return data
  }
}
