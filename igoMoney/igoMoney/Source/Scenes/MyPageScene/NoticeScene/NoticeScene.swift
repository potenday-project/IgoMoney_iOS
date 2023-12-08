//
//  NoticeSceen.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct NoticeCore: Reducer {
  struct State: Equatable {
    var notices: [Notice] = []
  }
  
  enum Action: Equatable {
    case onAppear
    
    case _fetchAllNotice
    case _fetchNoticesResponse(TaskResult<[Notice]>)
  }
  
  @Dependency(\.noticeClient) var noticeClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .send(._fetchAllNotice)
      
    case ._fetchAllNotice:
      return .run { send in
        await send(
          ._fetchNoticesResponse(
            TaskResult {
              try await noticeClient.fetchAllNotice(0)
            }
          )
        )
      }
    case ._fetchNoticesResponse(.success(let notices)):
      state.notices = notices
      return .none
      
    case ._fetchNoticesResponse(.failure):
      return .none
    }
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
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 24)
        
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 16) {
            ForEach(viewStore.notices, id: \.ID) { notice in
              NoticeCell(notice: notice)
            }
          }
        }
        
        Spacer()
      }
    }
  }
}

struct NoticeCell: View {
  let notice: Notice
  @State var isFold: Bool = true
  
  var body: some View {
    VStack(spacing: 16) {
      HStack {
        Text(notice.title)
          .font(.pretendard(size: 16, weight: .semiBold))
        
        Spacer()
        
        Button {
          withAnimation {
            isFold.toggle()
          }
        } label: {
          Image(systemName: isFold ? "chevron.down" : "chevron.up")
        }
        .foregroundColor(ColorConstants.gray4)
      }
      .padding(.horizontal)
      
      HStack {
        Text(notice.createdDate)
        
        Spacer()
      }
      .font(.pretendard(size: 12, weight: .medium))
      .foregroundColor(ColorConstants.gray2)
      .padding(.horizontal)
      
      if isFold == false {
        Text(notice.content)
          .padding()
          .background(ColorConstants.gray5)
          .font(.pretendard(size: 14, weight: .medium))
      }
    }
    .padding()
  }
}

#Preview {
  NoticeScene(
    store: Store(
      initialState: NoticeCore.State(notices: Notice.default),
      reducer: { NoticeCore() }
    )
  )
}
