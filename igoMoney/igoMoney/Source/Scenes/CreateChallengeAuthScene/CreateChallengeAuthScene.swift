//
//  CreateChallengeAuthScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct CreateChallengeAuthScene: View {
  let store: StoreOf<CreateChallengeAuthCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 24) {
        IGONavigationBar {
          Text("9월 24일 1일차")
            .font(.pretendard(size: 20, weight: .bold))
        } leftView: {
          Button {
            
          } label: {
            Image(systemName: "xmark")
          }
          .frame(width: 24, height: 24)
          .foregroundColor(.black)
        } rightView: {
          EmptyView()
        }
        .padding(.top, 16)
        
        ScrollView(.vertical, showsIndicators: false) {
          VStack {
            ChallengeAuthImageListSection()
            
            ChallengeAuthMoneyInputSection(
              money: viewStore.binding(
                get: \.money,
                send: CreateChallengeAuthCore.Action.moneyChanged
              )
            )
            
            ChallengeAuthTitleSection()
            
            ChallengeAuthContentSection()
          }
          .padding(.horizontal, 24)
        }
        
        Spacer()
        
        Button {
          
        } label: {
          Text("인증하기")
            .font(.pretendard(size: 18, weight: .bold))
        }
        .foregroundColor(ColorConstants.gray4)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(ColorConstants.gray5)
        .cornerRadius(8)
        .padding(.horizontal, 24)
      }
    }
  }
}

struct ChallengeAuthImageListSection: View {
  var body: some View {
    Section {
      InputHeaderView(title: "인증 사진", detail: "선택, 최대 1장")
      
      Button {
        
      } label: {
        VStack(spacing: 8) {
          Image("icon_add_photo")
          
          Text("이미지 등록하기")
            .font(.pretendard(size: 16, weight: .semiBold))
            .foregroundColor(.black)
        }
        .padding(.vertical, 15)
      }
      .frame(maxWidth: .infinity)
      .background(Color.white)
      .cornerRadius(8)
      .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(0..<5) { _ in
            Image("example_food")
              .resizable()
              .frame(width: 100, height: 100)
              .clipShape(RoundedRectangle(cornerRadius: 8))
              .overlay(
                Button {
                  
                } label: {
                  Image(systemName: "xmark.circle.fill")
                }
                  .font(.pretendard(size: 18, weight: .regular))
                  .foregroundColor(ColorConstants.gray4)
                  .padding(3)
                
                ,alignment: .topTrailing
              )
          }
        }
        .padding(.horizontal, 24)
      }
    }
  }
}

struct ChallengeAuthMoneyInputSection: View {
  @Binding var money: String
  var body: some View {
    Section {
      InputHeaderView(title: "금액", detail: "숫자만 입력")
      
      IGOTextField(
        text: $money,
        placeholder: "금액을 입력해주세요.",
        placeholderColor: ColorConstants.gray4
      )
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(
        RoundedRectangle(cornerRadius: 4)
          .stroke(ColorConstants.gray4)
      )
    }
  }
}

struct ChallengeAuthTitleSection: View {
  var body: some View {
    Section {
      InputHeaderView(title: "제목", detail: "최소 5자 / 최대 15자")
      
      IGOTextField(
        text: .constant(""),
        placeholder: "제목을 입력해주세요.",
        placeholderColor: ColorConstants.gray4
      )
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(
        RoundedRectangle(cornerRadius: 4)
          .stroke(ColorConstants.gray4)
      )
    }
  }
}

struct ChallengeAuthContentSection: View {
  var body: some View {
    Section {
      InputHeaderView(title: "내용", detail: "최소 3자 / 최대 100자")
      
      TextEditor(
        text: .constant("")
      )
      .font(.pretendard(size: 16, weight: .medium))
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .textEditorBackground {
        RoundedRectangle(cornerRadius: 4)
          .stroke(ColorConstants.gray4, lineWidth: 2)
          .background(Color.clear)
          .cornerRadius(4)
      }
      .frame(height: 100)
      
    }
  }
}
