//
//  ProfileSettingView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ProfileSettingView: View {
    var body: some View {
        VStack {
            Text("ProfileSetting")
        }
        .navigationBarHidden(false)
        .onAppear {
            UINavigationBar.appearance().tintColor = UIColor.gray.withAlphaComponent(0.3)
        }
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileSettingView()
        }
    }
}
