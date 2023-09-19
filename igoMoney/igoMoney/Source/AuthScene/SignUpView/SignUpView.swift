//
//  SignUpView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct SignUpView: View {
    let store: StoreOf<SignUpCore>
    
    @ViewBuilder
    private func informationBaseView(with text: String) -> some View {
        HStack {
            Text(text)
            
            Spacer()
        }
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            informationBaseView(with: "약관에 동의해주세요.")
            informationBaseView(with: "필수항목에 대한 약관에 동의해주세요.")
            
            WithViewStore(store, observe: { $0 }) { viewStore in
                CheckButton(isAccentColor: viewStore.isAgreeAll) {
                    viewStore.send(.didTapAll)
                } content: {
                    Text("전체 동의")
                        .font(.system(size: 18, weight: .bold))
                }
            }
            
            CheckButton(isAccentColor: false, isHidden: true, action: { }) {
                Text("서비스 이용을 위해 아래 약관에 모두 동의합니다.")
                    .font(.system(size: 14, weight: .medium))
            }
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.vertical, 10)
            
            WithViewStore(store, observe: { $0 }) { viewStore in
                PrivacyCheckView(
                    title: "개인 정보 처리방침",
                    isAccentColor: viewStore.isAgreePrivacy
                ) {
                    viewStore.send(.didTapAgreePrivacy)
                } viewAction: {
                    print("Tapped 서비스 이용약관")
                }
            }

            WithViewStore(store, observe: { $0 }) { viewStore in
                PrivacyCheckView(
                    title: "서비스 이용약관",
                    isAccentColor: viewStore.isAgreeTerms
                ) {
                    viewStore.send(.didTapAgreeTerms)
                } viewAction: {
                    print("Tapped 서비스 이용약관")
                }
            }
            
            Spacer()
            
            WithViewStore(store, observe: { $0 }) { viewStore in
                Button {
                    viewStore.send(.didTapConfirm)
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("확인")
                        
                        Spacer()
                    }
                }
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(
                    viewStore.isAgreeAll ? .black : .gray.opacity(0.3)
                )
                .disabled(viewStore.isAgreeAll == false)
                .padding(.vertical)
                .background(
                    viewStore.isAgreeAll ? Color("AccentColor2") : .gray.opacity(0.3)
                )
                .cornerRadius(8)
                .padding(.bottom, 24)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct PrivacyCheckView: View {
    let title: String
    let isAccentColor: Bool
    let action: () -> Void
    let viewAction: () -> Void
    
    init(
        title: String,
        isAccentColor: Bool,
        action: @escaping () -> Void,
        viewAction: @escaping () -> Void
    ) {
        self.title = title
        self.isAccentColor = isAccentColor
        self.action = action
        self.viewAction = viewAction
    }
    
    var body: some View {
        CheckButton(isAccentColor: isAccentColor) {
            action()
        } content: {
            Text("필수")
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .regular))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(4)
            
            Text(title)
                .font(.system(size: 16, weight: .regular))
            
            Spacer()
            
            Button("보기") {
                viewAction()
            }
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.gray)
        }
    }
    
}

struct CheckButton<Content: View>: View {
    let isAccentColor: Bool
    let isHidden: Bool
    let action: () -> Void
    let content: () -> Content
    
    @ViewBuilder
    private func signUpCheckImage() -> some View {
        Image(systemName: "checkmark.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
    }
    
    init(
        isAccentColor: Bool,
        isHidden: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isAccentColor = isAccentColor
        self.isHidden = isHidden
        self.action = action
        self.content = content
    }
    
    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                signUpCheckImage()
                    .accentColor(
                        isAccentColor ? ColorConstants.primary : Color.gray.opacity(0.3)
                    )
            }
            .opacity(isHidden ? .zero : 1)
            .disabled(isHidden)
            
            content()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            store: Store(
                initialState: SignUpCore.State(),
                reducer: { SignUpCore() }
            )
        )
    }
}
