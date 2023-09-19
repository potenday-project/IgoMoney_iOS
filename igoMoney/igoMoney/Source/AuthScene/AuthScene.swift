//
//  OnBoardingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct OnBoardingScene: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 80)
            
            ImageScrollBannerView(store: Store(initialState: HelpScrollCore.State(), reducer: {
                HelpScrollCore()
                    ._printChanges()
            }))
            
            AuthButton(
                title: "카카오로 로그인",
                iconName: "icon_kakao",
                color: Color("kakao_color")
            ) {
                print("카카오")
            }
            .padding(.horizontal, 24)
            
            AuthButton(
                title: "애플로 로그인",
                iconName: "icon_apple",
                color: .white
            ) {
                print("애플")
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke()
            )
            .padding(.horizontal, 24)
        }
    }
}

struct OnBoarding_Preview: PreviewProvider {
    static var previews: some View {
        OnBoardingScene()
    }
}
