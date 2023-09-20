//
//  Bundle+Extensions.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Bundle {
    var kakaoNativeKey: String {
        guard let file = self.path(forResource: "KakaoService", ofType: "plist") else {
            return ""
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["NATIVE_APP_KEY"] as? String else {
            debugPrint("카카오 앱 Native 앱키를 설정 해주세요.")
            return ""
        }
        
        return key
    }
}
