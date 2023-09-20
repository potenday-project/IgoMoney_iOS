//
//  Provider.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

enum Provider: String, Equatable, CaseIterable, CustomStringConvertible {
    case kakao
    case apple
    
    var description: String {
        switch self {
        case .kakao:
            return "카카오로 로그인"
        case .apple:
            return "애플로 로그인"
        }
    }
    
    var iconName: String {
        return "icon_\(rawValue)"
    }
    
    var colorName: String {
        return "\(rawValue)_color"
    }
}
