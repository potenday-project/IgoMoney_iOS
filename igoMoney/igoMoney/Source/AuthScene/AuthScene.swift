//
//  OnBoardingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import AuthenticationServices
import SwiftUI

import ComposableArchitecture

struct AuthScene: View {
  let store: StoreOf<AuthCore>
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .top) {
        Color("background_color")
          .edgesIgnoringSafeArea(.all)
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          NavigationLink(
            destination: IfLetStore(
              store.scope(
                state: \.profileSettingState,
                action: AuthCore.Action.profileSettingAction
              )
            ) { store in
              ProfileSettingView(store: store)
            },
            isActive: viewStore.binding(
              get: \.showProfileSetting,
              send: AuthCore.Action.presentProfileSetting
            )
          ) {
            EmptyView()
          }
        }
        
        // Login Section
        VStack {
          HelpSection()
          
          WithViewStore(store, observe: { $0 }) { viewStore in
            ForEach(viewStore.providers, id: \.rawValue) { provider in
              IGOAuthButton(provider: provider) {
                Task {
                  if provider == .kakao {
                    let token = await AuthController.shared.authorizationWithKakao()
                    viewStore.send(._loginWithKakao)
                  }
                }
                
                if provider == .apple {
                  AuthController.shared.authorizationWithApple()
                }
              }
              .padding(.horizontal)
              .padding(.bottom, provider == .apple ? 80 : .zero)
            }
          }
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
      .navigationTitle("")
      .navigationBarHidden(true)
    }
    .navigationViewStyle(.stack)
  }
}

struct HelpSection: View {
  var body: some View {
    VStack {
      Spacer()
        .frame(height: 48)
      
      Image("icon_text_main")
      
      Spacer()
        .frame(height: 100)
      
      Image("icon_main")
      
      Spacer()
      
      VStack(spacing: 12) {
        Text(TextConstants.mainHelpText)
          .multilineTextAlignment(.center)
          .font(.system(size: 26, weight: .bold))
          .foregroundColor(.white)
        
        Text(TextConstants.subHelpText)
          .multilineTextAlignment(.center)
          .font(.system(size: 14, weight: .medium))
          .foregroundColor(.white)
      }
      
      Spacer()
        .frame(height: 80)
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

private extension HelpSection {
  enum TextConstants {
    static let mainHelpText = "일주일동안\n함께하는 챌린지"
    static let subHelpText = "돈을 절약하고 싶은 사람들과 함께 일주일\n버티기 챌린지에 도전해보세요!"
  }
}
