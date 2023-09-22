//
//  EnterChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct EnterChallengeScene: View {
  var body: some View {
    VStack {
      ZStack {
        HStack {
          Button {
            // TODO: - 뒤로가기 액션 추가하기
          } label: {
            Image(systemName: "chevron.left")
              .font(.pretendard(size: 22, weight: .bold))
          }
          
          Spacer()
        } // Left View
        
        HStack(spacing: .zero) {
          Spacer()
          
          Text("챌린지 참여하기")
            .font(.pretendard(size: 20, weight: .bold))
          
          Spacer()
        } // Title View
      } // Custom Navigation Bar
      .foregroundColor(.white)
      .padding(.horizontal, 24)
      
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          Text("오마이머니님 챌린지")
            .font(.pretendard(size: 14, weight: .bold))
            .foregroundColor(ColorConstants.gray2)
          
          Spacer()
          
          Text("30000원")
            .padding(.horizontal, 4)
            .font(.pretendard(size: 12, weight: .medium))
            .background(Color.red)
            .cornerRadius(4)
          
          Text("내일 부터 시작")
            .padding(.horizontal, 4)
            .font(.pretendard(size: 12, weight: .medium))
            .background(Color.red)
            .cornerRadius(4)
        } // Challenge Information Header
        .padding(.horizontal, 16)
        .padding(.top, 16)
        
        VStack(alignment: .leading, spacing: 8) {
          Text("일주일에 3만원으로 살아남기")
            .font(.pretendard(size: 18, weight: .bold))
          
          Text("내일부터 일주일 동안 30000원으로 누가 더 적게 쓰는지 저희 대결해요! 저는 최대한 커피 지출을 줄이고 싶어요!")
            .font(.pretendard(size: 14, weight: .medium))
        } // Challenge Information Body
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
      } // Challenge Information Section
      .background(ColorConstants.primary7)
      .cornerRadius(10)
      .padding(24)
      
      VStack(spacing: 16) {
        VStack {
          HStack {
            Text("📣 챌린지 진행 방법")
            
            Spacer()
          }
          .font(.pretendard(size: 18, weight: .bold))
          
          VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
              Text("1.")
              Text("참가 후 다음날부터 챌린지가 일주일동안 진행되요.")
            }
            
            HStack(alignment: .top) {
              Text("2.")
              Text("매일 내가 지출한 금액과 사진을 인증하세요.")
            }
            
            HStack(alignment: .top) {
              Text("3.")
              Text("목표 금액을 달성하면 승리합니다.\n(모두 목표 금액 달성 시, 적게 지출 한쪽이 승리합니다.)")
            }
            
            HStack(alignment: .top) {
              Text("4.")
              Text("챌린지에서 이기면 승리 뱃지를 지급해드려요.")
            }
          }
          .font(.pretendard(size: 13, weight: .medium))
          .padding(16)
          .background(Color.white)
          .cornerRadius(10)
          .shadow(color: ColorConstants.gray2.opacity(0.2), radius: 8, y: 2)
        } // Challenge Doing Information
        
        VStack {
          HStack {
            Text("📌 챌린지 진행 시 꼭 알아주세요!")
            
            Spacer()
          }
          .font(.pretendard(size: 18, weight: .bold))
          
          VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
              Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
              
              Text("하루에 최소 1번 인증샷과 지출 금액을 인증 해야합니다.")
            }
            
            HStack(alignment: .top) {
              Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
              
              Text("인증샷과 지출 금액은 상대방에게 공개됩니다.")
            }
            
            HStack(alignment: .top) {
              Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
              
              Text("챌린지를 포기할 경우 상대방이 승리하게 됩니다.")
            }
          }
          .font(.pretendard(size: 13, weight: .medium))
          .padding(16)
          .background(Color.white)
          .cornerRadius(10)
          .shadow(color: ColorConstants.gray2.opacity(0.2), radius: 8, y: 2)
        } // Challenge Notice Information
        
        Spacer()
        
        Button {
          // TODO: - Enter Action 추가하기
        } label: {
          HStack {
            Spacer()
            
            Text("챌린지 참여하기")
            
            Spacer()
          }
        } // Enter Button
        .font(.pretendard(size: 18, weight: .medium))
        .foregroundColor(.black)
        .padding(16)
        .background(ColorConstants.primary)
        .cornerRadius(8)
      }
      .padding(24)
      .background(
        Color.white
      )
      .cornerRadius(20, corner: .topLeft)
      .cornerRadius(20, corner: .topRight)
      .edgesIgnoringSafeArea(.all)
    }
    .background(
      Color("background_color")
        .edgesIgnoringSafeArea(.all)
    )
  }
}

struct EnterChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    EnterChallengeScene()
  }
}
