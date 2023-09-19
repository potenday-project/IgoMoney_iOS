//
//  ProfileSettingView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ProfileSettingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(TextConstants.nickNameTitle)
                .multilineTextAlignment(.leading)
                .font(.system(size: 20, weight: .bold))
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
                
                HStack {
                    TextField(TextConstants.nickNamePlaceholder, text: .constant(""))
                        .font(.system(size: 16, weight: .medium))
                    
                    Button {
                        print(123)
                    } label: {
                        Text(TextConstants.confirmDuplicateText)
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorConstants.gray7)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(ColorConstants.gray8)
                    .cornerRadius(.infinity)
                }
                .padding(12)
                .background(ColorConstants.primary7)
                .cornerRadius(8)
                
                // Reducer 상태에 따라서 값 변경
                Text("최소 3자 이상의 영문, 한글, 숫자만 입력해주세요.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorConstants.primary)
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
            ProfileSettingView()
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
