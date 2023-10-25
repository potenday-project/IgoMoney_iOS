//
//  NickNameInputView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct NickNameInputView: View {
  let placeholder: String
  let store: StoreOf<NickNameCheckDuplicateCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          TextField(
            placeholder,
            text: viewStore.binding(
              get: \.nickName,
              send: NickNameCheckDuplicateCore.Action._changeText
            )
          )
          .font(.system(size: 16, weight: .medium))
          
          Button {
            viewStore.send(.confirmNickName)
          } label: {
            Text("중복확인")
          }
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(
            viewStore.nickNameState == .disableConfirm ? ColorConstants.gray4 : .white
          )
          .padding(.horizontal, 8)
          .padding(.vertical, 5)
          .background(
            viewStore.nickNameState == .disableConfirm ?
            ColorConstants.gray4 : viewStore.nickNameState == .completeConfirm ?
            ColorConstants.primary3 : ColorConstants.primary
          )
          .cornerRadius(.infinity)
          .opacity(viewStore.nickNameState == .disableConfirm ? .zero : 1)
          .disabled(viewStore.nickNameState == .disableConfirm)
        } // NickName Input
        .padding(12)
        .background(ColorConstants.primary7)
        .cornerRadius(8)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(
              viewStore.nickNameState == .disableConfirm ?
              ColorConstants.gray5 : ColorConstants.primary
            )
        )
        
        Text(viewStore.nickNameState.description)
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(
            viewStore.nickNameState == .duplicateNickName ? Color.red : .black
          )
      }
    }
  }
}
