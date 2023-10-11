//
//  GenerateRoomScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct GenerateRoomScene: View {
  @State private var title: String = ""
  @State private var content: String = ""
  
  var body: some View {
    VStack(spacing: 24) {
      // 네비게이션 바
      IGONavigationBar {
        Text("챌린지 만들기")
          .font(.pretendard(size: 20, weight: .bold))
      } leftView: {
        Button {
          print("Tapped Dismiss")
        } label: {
          Image(systemName: "xmark")
            .resizable()
            .frame(width: 14, height: 14)
        }
      }
      .fixedSize(horizontal: false, vertical: true)
      .padding(.horizontal, 24)
      .padding(.top, 16)
      
      ScrollView {
        VStack(spacing: 24) {
          // 챌린지 금액 섹션
          Section {
            VStack(alignment: .leading, spacing: 12) {
              HStack {
                Text("챌린지 금액")
                  .font(.pretendard(size: 18, weight: .bold))
                
                Spacer()
              }
              
              HStack {
                ForEach(1...5, id: \.self) { index in
                  Button {
                    print("Tapped \(index)")
                  } label: {
                    Text(index.description + "만원")
                      .frame(maxWidth: .infinity)
                      .padding(.vertical, 8)
                  }
                  .buttonStyle(.plain)
                  .background(ColorConstants.primary7)
                  .overlay(
                    RoundedRectangle(cornerRadius: 4)
                      .stroke(ColorConstants.primary, lineWidth: 1)
                  )
                }
              }
            }
          }
          
          // 챌린지 주제 섹션
          Section {
            VStack {
              HStack {
                Text("챌린지 주제")
                  .font(.pretendard(size: 18, weight: .bold))
                
                Spacer()
              }
              
              LazyVGrid(columns: Array(repeating: .init(), count: 3), spacing: 16) {
                ForEach(1...5, id: \.self) { index in
                  VStack(spacing: 8) {
                    Text("💸")
                      .font(.pretendard(size: 28, weight: .bold))
                      .frame(maxWidth: .infinity)
                    
                    Text("생활비")
                      .font(.pretendard(size: 14, weight: .bold))
                      .frame(maxWidth: .infinity)
                  }
                  .padding(.vertical, 12)
                  .background(ColorConstants.primary7)
                  .overlay(
                    RoundedRectangle(cornerRadius: 4)
                      .stroke(ColorConstants.primary, lineWidth: 1)
                  )
                }
              }
            }
          }
          
          // 챌린지 시작일 섹션
          Section {
            VStack {
              HStack {
                Text("챌린지 시작일")
                  .font(.pretendard(size: 18, weight: .bold))
                
                Spacer()
              }
              
              Button {
                
              } label: {
                HStack {
                  Image(systemName: "calendar")
                  
                  Text("챌린지 시작일을 선택해주세요.")
                  
                  Spacer()
                }
                .font(.pretendard(size: 16, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
              }
              .foregroundColor(ColorConstants.gray3)
              .buttonStyle(.plain)
              .background(
                RoundedRectangle(cornerRadius: 4)
                  .stroke(ColorConstants.gray3)
              )
            }
          }
          
          // 챌린지 제목 섹션
          Section {
            HStack(alignment: .center) {
              Text("제목")
                .font(.pretendard(size: 18, weight: .bold))
              
              Spacer()
              
              Text("최소 5자 / 최대 15자")
                .font(.pretendard(size: 12, weight: .medium))
                .foregroundColor(ColorConstants.gray3)
            }
            
            TextField("제목을 입력해주세요.", text: $title)
              .padding(.horizontal, 16)
              .padding(.vertical, 12)
              .background(
                RoundedRectangle(cornerRadius: 4)
                  .stroke(ColorConstants.gray3)
              )
          }
          
          // 챌린지 내용 섹션
          Section {
            HStack(alignment: .center) {
              Text("내용")
                .font(.pretendard(size: 18, weight: .bold))
              
              Spacer()
              
              Text("최대 50자")
                .font(.pretendard(size: 12, weight: .medium))
                .foregroundColor(ColorConstants.gray3)
            }
            
            // TODO: - Custom TextView 구현하기
          }
        }
        .padding(.horizontal, 24)
      }
      
      Button {
        print("Tapped Complete Button")
      } label: {
        Text("완료")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.plain)
      .padding(16)
      .foregroundColor(ColorConstants.gray3)
      .background(ColorConstants.gray5)
      .cornerRadius(8)
      .padding(.horizontal, 24)
    }
  }
}

#Preview {
  GenerateRoomScene()
}
