//
//  ProfileSettingView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ProfileSettingView: View {
    let store: StoreOf<ProfileSettingCore>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(TextConstants.nickNameTitle)
                .multilineTextAlignment(.leading)
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 26)
                .padding(.horizontal, 24)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(TextConstants.nickName)
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                    
                    Text(TextConstants.nickNameRuleText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorConstants.gray6)
                }
                
                WithViewStore(store, observe: { $0 }) { viewStore in
                    HStack {
                        TextField(
                            TextConstants.nickNamePlaceholder,
                            text: viewStore.binding(
                                get: \.nickName,
                                send: ProfileSettingCore.Action._changeText
                            )
                        )
                        .font(.system(size: 16, weight: .medium))
                        
                        Button {
                            viewStore.send(.confirmNickName)
                        } label: {
                            Text(TextConstants.confirmDuplicateText)
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(
                            viewStore.nickNameState == .disableConfirm ? ColorConstants.gray7 : .white
                        )
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(
                            viewStore.nickNameState == .disableConfirm ?
                            ColorConstants.gray7 : viewStore.nickNameState == .completeConfirm ?
                            ColorConstants.primary3 : ColorConstants.primary
                        )
                        .cornerRadius(.infinity)
                        .opacity(viewStore.nickNameState == .disableConfirm ? .zero : 1)
                        .disabled(viewStore.nickNameState == .disableConfirm)
                    }
                    .padding(12)
                    .background(ColorConstants.primary7)
                    .cornerRadius(8)
                }
                
                WithViewStore(store, observe: { $0 }) { viewStore in
                    Text(viewStore.nickNameState.description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(
                            viewStore.nickNameState == .duplicateNickName ? Color.red : .black
                        )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                print(123)
            } label: {
                HStack {
                    Spacer()
                    
                    Text(TextConstants.startText)
                    
                    Spacer()
                }
            }
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(ColorConstants.gray7)
            .padding(.vertical)
            .background(ColorConstants.gray8)
            .cornerRadius(8)
            .padding([.horizontal, .bottom], 24)
        }
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            UINavigationBar.appearance().tintColor = UIColor.gray.withAlphaComponent(0.3)
        }
    }
}

struct ProfileSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileSettingView(
                store: Store(
                    initialState: ProfileSettingCore.State(),
                    reducer: { ProfileSettingCore() }
                )
            )
        }
    }
}

private extension ProfileSettingView {
    enum TextConstants {
        static let nickNameTitle = "반가워요!\n닉네임을 설정해주세요."
        static let nickName = "닉네임"
        static let nickNameRuleText = "최소 3자 / 최대 8자"
        static let nickNamePlaceholder = "한글, 영어, 숫자만 사용가능합니다."
        static let confirmDuplicateText = "중복확인"
        static let startText = "챌린지 시작하기"
    }
}
