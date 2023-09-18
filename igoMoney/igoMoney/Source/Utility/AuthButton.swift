//
//  AuthButton.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct AuthButton: View {
    let title: String
    let iconName: String
    let color: Color
    let action: () -> Void
    
    init(
        title: String,
        iconName: String,
        color: Color,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(iconName)
                
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .padding(.vertical, 16)
            .background(color)
            .cornerRadius(8)
        }
    }
}
