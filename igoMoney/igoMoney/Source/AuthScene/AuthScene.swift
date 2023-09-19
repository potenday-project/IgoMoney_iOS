//
//  OnBoardingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct AuthScene: View {
    let store: StoreOf<AuthCore>
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 80)
            
            HelpScrollView(
                store: store.scope(
                    state: \.helpState,
                    action: AuthCore.Action.helpAction
                )
            )
            
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
        AuthScene(
            store: Store(
                initialState: AuthCore.State(),
                reducer: { AuthCore() }
            )
        )
    }
}
