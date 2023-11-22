//
//  APIError.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

enum APIError: Error {
  case tokenExpired
  case didNotConvertRequest
  case invalidResponse
  
  case informationResponse
  case redirect
  case badRequest(Int)
  case invalidServer(Int)
  
  case couldNotConvertJson
}
