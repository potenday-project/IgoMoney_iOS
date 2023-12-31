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
        TabView {
          ForEachStore(
            self.store.scope(
              state: \.imageStates,
              action: ChallengeRecordDetailCore.Action.urlImageAction
            )
          ) { imageStore in
            URLImage(store: imageStore)
              .aspectRatio(1, contentMode: .fill)
              .cornerRadius(8)
              .clipped()
              .onAppear {
                let id = imageStore.withState { $0.id }
                self.store.send(.onChangeImage(id))
                imageStore.send(.fetchURLImage)
              }
          }
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .indexViewStyle(.page(backgroundDisplayMode: .never))
      .cornerRadius(8)
      .overlay(
        HStack(spacing: .zero) {
          Text("\(store.withState(\.selectedIndex))")
            .foregroundColor(ColorConstants.gray4)
          
          Text(" / \(store.withState(\.imageStates).count)")
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
    .igoAlert(
      self.store.scope(
        state: \.deleteAlertState,
        action: ChallengeRecordDetailCore.Action.alertAction
      )
    ) {
      VStack(spacing: 16) {
        Text("인증을 삭제하시겠습니까?")
          .font(.pretendard(size: 18, weight: .bold))
          .multilineTextAlignment(.center)
        
        HStack {
          Button {
            self.store.send(.showDeleteRecord(false))
          } label: {
            Text("취소")
              .frame(maxWidth: .infinity)
              .font(.pretendard(size: 16, weight: .medium))
              .foregroundColor(ColorConstants.gray3)
          }
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .background(ColorConstants.gray5)
          .cornerRadius(8)
          
          Button {
            self.store.send(.deleteRecord)
          } label: {
            Text("삭제")
              .frame(maxWidth: .infinity)
              .font(.pretendard(size: 16, weight: .medium))
          }
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .background(ColorConstants.primary)
          .cornerRadius(8)
        }
      }
      .foregroundColor(Color.black)
      .padding()
      .background(Color.white)
      .cornerRadius(8)
      .frame(width: 250)
    }
    .onAppear {
      UIScrollView.appearance().isPagingEnabled = true
    }
    .onDisappear {
      UIScrollView.appearance().isPagingEnabled = false
    }
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
              viewStore.send(.showDeleteRecord(true))
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
        Menu {
          Button {
            // TODO: - 신고 화면 이동
            viewStore.send(.showDeclarationView(true))
          } label: {
            Text("신고하기")
          }
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
  }
}
