//
//  MultipartForm.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct MultipartForm {
  enum FormData {
    case text(String)
    case image(Data)
  }
  
  let boundary: String
  var values: [String: FormData]
}

extension MultipartForm {
  func httpBody() -> Data {
    var data = Data()
    
    values.forEach { (key, value) in
      data.appendString(to: "--\(boundary)\r\n")
      print("Append Data", (key, value))
      switch value {
      case .text(let text):
        data.appendString(to: "Content-Disposition: form-data; name=\"\(key)\"\r\n")
        data.appendString(to: "Content-Type: text/plain; charset=utf-8\r\n\r\n")
        data.appendString(to: "\(text)\r\n")
      case .image(let imageData):
        data.appendString(to: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"profile.jpg\"\r\n")
        data.appendString(to: "Content-Type: image/png\r\n\r\n")
        data.append(imageData)
        data.appendString(to: "\r\n")
      }
    }
    data.appendString(to: "--\(boundary)--\r\n")
    return data
  }
}

extension Data {
  mutating func appendString(to value: String) {
    if let data = value.data(using: .utf8, allowLossyConversion: true) {
      self.append(data)
    }
  }
}
