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
        .padding(.horizontal, 24)
        
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 24) {
            ChallengeAuthImageListSection(viewStore: viewStore)
            
            ChallengeAuthMoneyInputSection(
              money: viewStore.binding(
                get: \.money,
                send: CreateChallengeAuthCore.Action.moneyChanged
              )
            )
            .padding(.horizontal, 24)
            
            ChallengeAuthTitleSection(
              title: viewStore.binding(
                get: \.title,
                send: CreateChallengeAuthCore.Action.titleChanged
              )
            )
            .padding(.horizontal, 24)
            
            ChallengeAuthContentSection(
              content: viewStore.binding(
                get: \.content,
                send: CreateChallengeAuthCore.Action.contentChanged
              )
            )
            .padding(.horizontal, 24)
            
            Spacer()
          }
        }
        
        Button {
          viewStore.send(.registerRecord)
        } label: {
          Text("인증하기")
            .font(.pretendard(size: 18, weight: .bold))
        }
        .disabled(viewStore.isAvailableRegister == false)
        .foregroundColor(
          viewStore.isAvailableRegister ? Color.black : ColorConstants.gray4
        )
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
          viewStore.isAvailableRegister ? ColorConstants.primary : ColorConstants.gray5
        )
        .cornerRadius(8)
        .padding(.horizontal, 24)
        .buttonStyle(.plain)
        .padding(.bottom, 16)
      }
    }
  }
}

struct ChallengeAuthImageListSection: View {
  let viewStore: ViewStoreOf<CreateChallengeAuthCore>
  
  var body: some View {
    Section {
      InputHeaderView(title: "인증 사진", detail: "선택, 최대 1장")
        .padding(.horizontal, 24)
      
      Button {
        viewStore.send(.showPicker(true))
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
      .padding(.horizontal, 24)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(viewStore.authImages, id: \.self) { uiimage in
            Image(uiImage: uiimage)
              .resizable()
              .scaledToFill()
              .frame(width: 100, height: 100)
              .clipShape(RoundedRectangle(cornerRadius: 8))
              .overlay(
                Button {
                  viewStore.send(.imageRemove(uiimage))
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
    .fullScreenCover(
      isPresented: viewStore.binding(
        get: \.isShowImagePicker,
        send: CreateChallengeAuthCore.Action.showPicker
      )
    ) {
      IGOPhotoPicker(configuration: .init(photoLibrary: .shared())) { uiimage in
        viewStore.send(.imageAdd(uiimage))
      }
    }
  }
}

struct ChallengeAuthMoneyInputSection: View {
  @Binding var money: String
  var isAvailable: Bool {
    return Int($money.wrappedValue) != nil
  }
  
  var body: some View {
    Section {
      InputHeaderView(title: "금액", detail: "숫자만 입력")
      
      IGOTextField(
        text: $money,
        placeholder: "금액을 입력해주세요.",
        placeholderColor: ColorConstants.gray4
      )
      .keyboardType(.numberPad)
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(
        RoundedRectangle(cornerRadius: 4)
          .stroke(isAvailable ? ColorConstants.primary : ColorConstants.gray4)
          .background(isAvailable ? ColorConstants.primary7 : Color.white)
      )
    }
  }
}

struct ChallengeAuthTitleSection: View {
  @Binding var title: String
  var isAvailable: Bool {
    return (5...15) ~= $title.wrappedValue.count
  }
  
  var body: some View {
    Section {
      InputHeaderView(title: "제목", detail: "최소 5자 / 최대 15자")
      
      IGOTextField(
        text: $title,
        placeholder: "제목을 입력해주세요.",
        placeholderColor: ColorConstants.gray4
      )
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(
        RoundedRectangle(cornerRadius: 4)
          .stroke(isAvailable ? ColorConstants.primary : ColorConstants.gray4)
          .background(isAvailable ? ColorConstants.primary7 : Color.white)
      )
    }
    .onChange(of: isAvailable) {
      print($0)
    }
  }
}

struct ChallengeAuthContentSection: View {
  @Binding var content: String
  var isAvailable: Bool {
    return (3...100) ~= content.count
  }
  
  var body: some View {
    Section {
      InputHeaderView(title: "내용", detail: "최소 3자 / 최대 100자")
      
      TextEditor(text: $content)
        .font(.pretendard(size: 16, weight: .medium))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .textEditorBackground {
          RoundedRectangle(cornerRadius: 4)
            .stroke(
              isAvailable ? ColorConstants.primary : ColorConstants.gray4,
              lineWidth: 2
            )
            .background(isAvailable ? ColorConstants.primary7 : Color.white)
            .cornerRadius(4)
        }
        .frame(height: 100)
      
    }
  }
}

#Preview {
  CreateChallengeAuthScene(
    store: Store(
      initialState: CreateChallengeAuthCore.State(challenge: .default),
      reducer: { CreateChallengeAuthCore() }
    )
  )
}
