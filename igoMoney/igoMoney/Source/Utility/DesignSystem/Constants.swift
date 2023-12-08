//
//  Constants.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

enum ColorConstants {
  static let primary = Color("AccentColor")
  static let primary2 = Color("AccentColor2")
  static let primary3 = Color("AccentColor3")
  static let primary4 = Color("AccentColor4")
  static let primary5 = Color("AccentColor5")
  static let primary6 = Color("AccentColor6")
  static let primary7 = Color("AccentColor7")
  static let primary8 = Color("AccentColor8")
  
  static let gray = Color("gray")
  static let gray2 = Color("gray2")
  static let gray3 = Color("gray3")
  static let gray4 = Color("gray4")
  static let gray5 = Color("gray5")
  
  static let red = Color("red")
  static let orange = Color("Orange")
  static let yellow = Color("yellow")
  static let blue = Color("blue")
  static let purple = Color("purple")
  
  static let warning = Color("alert")
}

extension Color {
  var uiColor: UIColor {
    return UIColor(self)
  }
}

enum SystemConfigConstants {
  static let tokenService = "com.igo.igomoney"
  static let userIdentifierService = "userIdentifier"
  
  static let privacyURLString = "https://scarlet-tsunami-ae6.notion.site/1108380d3ad64a2f987134e283220852?pvs=4"
  static let termURLString = "https://scarlet-tsunami-ae6.notion.site/9c400f50565d45508eaaae7cc6c312f8?pvs=4"
}
