//
//  OnBoardingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct AuthScene: View {
    let store: StoreOf<AuthCore>
    @State private var showSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // Login Section
            VStack {
                HelpScrollView(
                    store: store.scope(
                        state: \.helpState,
                        action: AuthCore.Action.helpAction
                    )
                )
                .padding(.top, 80)
                
                Spacer()
                
                WithViewStore(store, observe: { $0 }) { viewStore in
                    AuthButton(
                        title: "카카오로 로그인",
                        iconName: "icon_kakao",
                        color: Color("kakao_color")
                    ) {
                        viewStore.send(.didTapKakaoLogin)
                    }
                    .padding(.horizontal, 24)
                }
                
                
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
                .padding(.bottom, 80)
            }
            
            IfLetStore(
                store.scope(
                    state: \.signUpState,
                    action: AuthCore.Action.signUpAction
                )
            ) { store in
                ZStack {
                    WithViewStore(self.store, observe: { $0 }) { viewStore in
                        Color.gray.opacity(0.2)
                            .onTapGesture {
                                viewStore.send(.presentSignUp(false))
                            }
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    SignUpView(store: store)
                        .padding(.top, UIScreen.main.bounds.height / 2)
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: UUID())
                }
            }
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
