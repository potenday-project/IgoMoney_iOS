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
            Text("반가워요!\n닉네임을 설정해주세요.")
                .multilineTextAlignment(.leading)
                .font(.system(size: 20, weight: .bold))
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("닉네임")
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                    
                    Text("최소 3자 / 최대 8자")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorConstants.gray6)
                }
                
                HStack {
                    TextField("한글, 영어, 숫자만 사용가능합니다.", text: .constant(""))
                        .font(.system(size: 16, weight: .medium))
                    
                    Button {
                        print(123)
                    } label: {
                        Text("중복확인")
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
                
                Text("최소 3자 이상의 영문, 한글, 숫자만 입력해주세요.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorConstants.primary)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                print(123)
            } label: {
                HStack {
                    Spacer()
                    
                    Text("챌린지 시작하기")
                    
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
