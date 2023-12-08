//
//  NoticeSceen.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct NoticeCore: Reducer {
  struct State: Equatable {
    
  }
  
  enum Action: Equatable {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

struct NoticeScene: View {
  let store: StoreOf<NoticeCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        IGONavigationBar {
          Text("공지사항")
        } leftView: {
          Button {
            
          } label: {
            Image(systemName: "chevron.backward")
          }
          .buttonStyle(.plain)
          .foregroundColor(.black)
        } rightView: {
          EmptyView()
        }
        .font(.pretendard(size: 20, weight: .bold))
      }
      .padding(.horizontal, 24)
      .padding(.top, 16)
      .padding(.bottom, 24)
    }
  }
}

#Preview {
  NoticeScene(
    store: Store(
      initialState: NoticeCore.State(),
      reducer: { NoticeCore() }
    )
  )
}
