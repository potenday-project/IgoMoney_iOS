//
//  ChallengeDetailDialog.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ChallengeDetailDialog: View {
  let store: StoreOf<ChallengeRecordDetailCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      /// Header Control Section
      ChallengeDetailHeaderView(store: store)
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        Text(viewStore.record.dateDescription)
          .font(.pretendard(size: 16, weight: .bold))
        
        Divider()
          .padding(.vertical, 8)
        
        Text(viewStore.cost.description + "원 지출")
          .font(.pretendard(size: 16, weight: .medium))
      }
      
      Divider().padding(.vertical, 8)
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        TabView(
          selection: viewStore.binding(
            get: \.selectedIndex,
            send: ChallengeRecordDetailCore.Action.selectImageIndex
          )
        ) {
          ForEach(0..<5) { index in
            URLImage(
              store: store.scope(
                state: \.imageState,
                action: ChallengeRecordDetailCore.Action.urlImageAction
              )
            )
            .scaledToFill()
            .frame(maxHeight: 280)
            .tag(index)
          }
        }
      }
      .frame(maxHeight: 280)
      .tabViewStyle(.page(indexDisplayMode: .never))
      .indexViewStyle(.page(backgroundDisplayMode: .never))
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay(
        HStack(spacing: .zero) {
          Text("\(store.withState(\.selectedIndex))")
            .foregroundColor(ColorConstants.gray4)
          
          Text(" / \(5)")
            .foregroundColor(ColorConstants.gray2)
        }.font(.pretendard(size: 11, weight: .medium))
          .padding(.horizontal, 8)
          .padding(.vertical, 2)
          .background(ColorConstants.gray3)
          .cornerRadius(.infinity)
          .padding(12),
        alignment: .bottomTrailing
      )
      
      Divider()
        .padding(.vertical, 8)
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        TextField(
          "",
          text: viewStore.binding(
            get: \.title,
            send: ChallengeRecordDetailCore.Action.onChangeTitle
          )
        )
        .font(.pretendard(size: 16, weight: .bold))
        .disabled(viewStore.isEditable == false)
      }
      
      Divider()
        .padding(.vertical, 8)
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        TextField(
          "",
          text: viewStore.binding(
            get: \.content,
            send: ChallengeRecordDetailCore.Action.onChangeContent
          )
        )
        .font(.pretendard(size: 14, weight: .bold))
        .disabled(viewStore.isEditable == false)
      }
    }
    .padding(24)
    .background(Color.white)
    .cornerRadius(8)
    .padding()
  }
}

struct ChallengeDetailHeaderView: View {
  let store: StoreOf<ChallengeRecordDetailCore>
  
  @ViewBuilder
  private func trailingButtonGroup() -> some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      if viewStore.isMine {
        if viewStore.isEditable {
          Button {
            viewStore.send(.didFinishUpdateContent)
          } label: {
            Text("완료")
          }
          .font(.pretendard(size: 16, weight: .bold))
          .buttonStyle(.plain)
          .foregroundColor(.black)
        } else {
          Button {
            store.send(.onChangeEditable(true))
          } label: {
            Image("icon_pancil")
          }
          .padding(.trailing, 8)
          
          Menu {
            Button {
              viewStore.send(.deleteRecord)
            } label: {
              Label("삭제하기", image: "trash")
            }
          } label: {
            Image("icon_dot3")
              .resizable()
              .scaledToFit()
              .frame(width: 24, height: 24)
          }
        }
      } else {
        Button {
          
        } label: {
          Image("icon_notification")
        }
      }
    }
  }
  
  var body: some View {
    HStack(spacing: .zero) {
      Button {
        store.send(.onDisappear)
      } label: {
        Image("icon_xmark")
      }
      
      Spacer()
      
      trailingButtonGroup()
    }
    .padding(.bottom, 24)
  }
}

#Preview {
  ZStack {
    Color.gray
    
    ChallengeDetailDialog(
      store: Store(
        initialState: ChallengeRecordDetailCore.State(record: .default, isMine: true),
        reducer: { ChallengeRecordDetailCore() }
      )
    )
    .frame(height: UIScreen.main.bounds.height * 0.7)
  }
}
