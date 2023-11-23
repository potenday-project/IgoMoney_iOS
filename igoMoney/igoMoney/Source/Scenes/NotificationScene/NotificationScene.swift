//
//  NotificationScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct NotificationScene: View {
  let store: StoreOf<NotificationCore>
  
  var body: some View {
    VStack(spacing: 24) {
      IGONavigationBar {
        Text("알림")
          .font(.pretendard(size: 20, weight: .bold))
      } leftView: {
        Button {
          
        } label: {
          Image(systemName: "chevron.backward")
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 20)
        }
        .buttonStyle(.plain)
      } rightView: {
        EmptyView()
      }
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        if viewStore.unreadNotifications.isEmpty {
          NotificationEmptyView()
        } else {
          List(viewStore.unreadNotifications, id: \.ID) { notification in
            NotificationCell(notification: notification)
          }
          .listStyle(.plain)
        }
      }
      
      Spacer()
    }
    .padding(.horizontal, 24)
    .padding(.top, 16)
    .onAppear {
      store.send(.onAppear)
    }
    .navigationBarHidden(true)
  }
}

struct NotificationEmptyView: View {
  var body: some View {
    VStack {
      Image("icon_notification_off")
      
      Text("알림이 아직 없어요.")
        .font(.pretendard(size: 14, weight: .bold))
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 16)
    .padding(.vertical, 13)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
  }
}

struct NotificationCell: View {
  let notification: Notification
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Label(notification.title, image: "icon_bolt")
          .font(.pretendard(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray)
        
        Spacer()
      }
      
      Text(notification.content)
        .font(.pretendard(size: 14, weight: .bold))
        .multilineTextAlignment(.leading)
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 16)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
  }
}

#Preview {
  NotificationScene(
    store: Store(
      initialState: NotificationCore.State(),
      reducer: { NotificationCore() }
    )
  )
}
