//
//  MultipartForm.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct MultipartForm {
  let id = UUID()
  var values: [String: String]
  
  init(values: [String : String]) {
    self.values = values
  }
}

extension MultipartForm {
  func httpBody() -> Data {
    let boundary = "Boundary_\(id.uuidString)"
    
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
    
    return data
  }
}
