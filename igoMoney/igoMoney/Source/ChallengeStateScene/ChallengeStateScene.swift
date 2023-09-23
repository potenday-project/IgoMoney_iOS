//
//  ChallengeStateScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ChallengeStateScene: View {
  var body: some View {
    
    VStack {
      IGONavigationBar {
        EmptyView()
      } leftView: {
        Text("참여중인 챌린지")
          .font(.pretendard(size: 20, weight: .bold))
          .foregroundColor(.white)
      } rightView: {
        Button(action: { }) {
          Text("대결 포기하기")
        }
        .font(.pretendard(size: 12, weight: .medium))
        .foregroundColor(ColorConstants.gray4)
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 16)
      
      ScrollView {
        VStack {
          VStack(alignment: .leading, spacing: 2) {
            HStack {
              Text("뒷주머니님과 대결중")
                .font(.pretendard(size: 14, weight: .bold))
                .foregroundColor(ColorConstants.gray2)
              
              Spacer()
              
              Text("💸 30000원")
                .font(.pretendard(size: 12, weight: .medium))
                .padding(.horizontal, 4)
                .background(ColorConstants.blue)
                .cornerRadius(4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            HStack {
              Text("일주일에 3만원으로 살아남기")
                .font(.pretendard(size: 16, weight: .bold))
              
              Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
          }
          .background(Color.white)
          .cornerRadius(10)
          .padding(.horizontal, 24)
          .padding(.top, 8)
          
          VStack(spacing: 8) {
            VStack {
              HStack(alignment: .bottom) {
                Text("아이고 머니님")
                  .font(.pretendard(size: 16, weight: .bold))
                
                Spacer()
                
                Text("30000원")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray2)
              }
              .padding(.top, 16)
              
              ZStack {
                RoundedRectangle(cornerRadius: .infinity)
                  .fill(ColorConstants.primary6)
                  .frame(maxWidth: .infinity, maxHeight: 8)
                  .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                      .fill(ColorConstants.primary2)
                      .frame(maxWidth: 100, maxHeight: 8),
                    alignment: .leading
                  )
              }
              
              HStack {
                Text("누적 금액")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray)
                
                Spacer()
                
                Text("3000원")
                  .foregroundColor(ColorConstants.primary2)
                  .font(.pretendard(size: 12, weight: .bold))
              }
            }
            
            Divider()
              .background(ColorConstants.gray4)
            
            VStack {
              HStack(alignment: .center) {
                Text("뒷주머니님")
                  .font(.pretendard(size: 16, weight: .bold))
                
                Spacer()
                
                Text("30000원")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray2)
              }
              
              ZStack {
                RoundedRectangle(cornerRadius: .infinity)
                  .fill(ColorConstants.primary6)
                  .frame(maxWidth: .infinity, maxHeight: 8)
                  .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                      .fill(ColorConstants.primary2)
                      .frame(maxWidth: 100, maxHeight: 8),
                    alignment: .leading
                  )
              }
              
              HStack {
                Text("누적 금액")
                  .font(.pretendard(size: 12, weight: .medium))
                  .foregroundColor(ColorConstants.gray)
                
                Spacer()
                
                Text("3000원")
                  .foregroundColor(ColorConstants.primary2)
                  .font(.pretendard(size: 12, weight: .bold))
              }
            }
            
            Divider()
              .background(ColorConstants.gray4)
            
            Text("현재 오마이머니님이 더 절약하고 있어요 🤔")
              .font(.pretendard(size: 14, weight: .bold))
              .padding(.bottom, 16)
          }
          .padding(.horizontal, 16)
          .background(ColorConstants.primary8)
          .cornerRadius(10)
          .padding(.horizontal, 24)
          .padding(.top, 16)
          
          VStack(spacing: .zero) {
            HStack {
              Button(action: { }) {
                Text("나의 챌린지")
              }
              .padding(.bottom, 8)
              .frame(maxWidth: .infinity)
              .overlay(
                Rectangle()
                  .frame(height: 1),
                alignment: .bottom
              )
              .accentColor(.black)
              
              Button(action: { }) {
                Text("상대방 챌린지")
              }
              .padding(.bottom, 8)
              .frame(maxWidth: .infinity)
              .overlay(
                Rectangle()
                  .frame(height: 1),
                alignment: .bottom
              )
              .foregroundColor(ColorConstants.gray3)
            }
            .font(.pretendard(size: 16, weight: .medium))
            .padding(.top, 12)
            .padding(.bottom, 24)
            .font(.pretendard(size: 16, weight: .bold))
            
            
            VStack(spacing: 12) {
              HStack {
                Text("🔥 9월 24일 일요일 1일차")
                
                Spacer()
              }
              .font(.pretendard(size: 18, weight: .bold))
              
              HStack(spacing: .zero) {
                ForEach(0..<7) { index in
                  VStack(spacing: 8) {
                    Text("9/24")
                      .font(.pretendard(size: 12, weight: .medium))
                      .frame(maxWidth: .infinity)
                    
                    Text("\(index + 1)일차")
                      .font(.pretendard(size: 14, weight: .semiBold))
                      .lineHeight(font: .pretendard(size: 14, weight: .semiBold), lineHeight: 21)
                      .frame(maxWidth: .infinity)
                    
                    Image(systemName: "checkmark.circle")
                      .frame(width: 20, height: 20)
                      .frame(maxWidth: .infinity)
                  }
                  .padding(.vertical, 8)
                  .foregroundColor(
                    index == .zero ? Color.black : ColorConstants.gray3
                  )
                  .background(
                    index == .zero ? ColorConstants.primary7 : .clear
                  )
                  .cornerRadius(8)
                }
              }
              .padding(.vertical, 12)
              .padding(.horizontal, 16)
              .background(Color.white)
              .cornerRadius(8)
              .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
            }
            .padding(.bottom, 16)
            
            Button(action: { }) {
              HStack(alignment: .center) {
                VStack(alignment: .leading) {
                  Text("9월 24일 1일차")
                    .font(.pretendard(size: 12, weight: .medium))
                    .foregroundColor(ColorConstants.gray)
                    .lineHeight(font: .pretendard(size: 12, weight: .medium), lineHeight: 16)
                  
                  Text("오늘 하루 지출 내역 입력하기")
                    .font(.pretendard(size: 16, weight: .bold))
                    .lineHeight(font: .pretendard(size: 16, weight: .bold), lineHeight: 23)
                    .foregroundColor(.black)
                }
                
                Spacer()
                
                Image("icon_edit")
              }
              .padding(16)
              .background(ColorConstants.primary8)
              .cornerRadius(10)
            }
            .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
          }
          .padding(.horizontal, 24)
          .padding(.bottom, 200)
          .background(Color.white)
          .cornerRadius(10, corner: .topLeft)
          .cornerRadius(10, corner: .topRight)
        }
      }
    }
    .navigationBarHidden(true)
    .background(
      Color("background_color")
        .edgesIgnoringSafeArea(.all)
    )
  }
}

struct ChallengeStateScene_Previews: PreviewProvider {
  static var previews: some View {
    ChallengeStateScene()
  }
}
