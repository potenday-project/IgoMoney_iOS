//
//  SignUpView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct SignUpView: View {
    let store: StoreOf<SignUpCore>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("약관에 동의해주세요.")
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
            }
            
            HStack {
                Text("필수항목에 대한 약관에 동의해주세요.")
                    .font(.system(size: 14))
                
                Spacer()
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("전체 동의")
                        .font(.system(size: 18, weight: .bold))
                }
                
                Text("서비스 이용을 위해 아래 약관에 모두 동의합니다.")
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.top, 8)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.vertical, 10)
            
            HStack {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text("필수")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .regular))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
                
                Text("개인 정보 처리 방침")
                    .font(.system(size: 16, weight: .regular))
                
                Spacer()
                
                Button("보기") {
                    print("Tapped 개인 정보 처리 방침"  )
                }
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            
            HStack {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text("필수")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .regular))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
                
                Text("서비스 이용약관")
                    .font(.system(size: 16, weight: .regular))
                
                Spacer()
                
                Button("보기") {
                    print("Tapped 개인 정보 처리 방침"  )
                }
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            
            Spacer()
            
            Button {
                print("Tapped Confirm")
            } label: {
                Text("확인")
            }
            .foregroundColor(.gray.opacity(0.3))
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)

            
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .edgesIgnoringSafeArea(.bottom)
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
