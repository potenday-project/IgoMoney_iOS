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
                Text("닉네임")
                    .font(.system(size: 18, weight: .bold))
                
                TextField("한글, 영어, 숫자만 사용가능합니다.", text: .constant(""))
                    .padding(12)
                    .background(ColorConstants.primary7)
                    .cornerRadius(8)
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
            .padding(.vertical)
            .background(Color.gray)
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
