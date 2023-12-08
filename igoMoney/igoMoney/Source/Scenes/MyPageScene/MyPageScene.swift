//
//  MyPageScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture
import MessageUI

struct MyPageScene: View {
  let store: StoreOf<MyPageCore>
  
  @ViewBuilder
  private func sectionHeaderView(title: String) -> some View {
    HStack {
      Text(title)
      
      Spacer()
    }
    .font(.pretendard(size: 18, weight: .bold))
  }
  
  var body: some View {
    VStack(spacing: .zero) {
      WithViewStore(store, observe: { $0 }) { viewStore in
        IGONavigationBar {
          EmptyView()
        } leftView: {
          Text("마이페이지")
            .font(.pretendard(size: 20, weight: .bold))
        } rightView: {
          NavigationLink(
            destination: GeneralSettingScene(
              store: store.scope(
                state: \.settingState,
                action: MyPageCore.Action.settingAction
              )
            ),
            label: {
              Image("icon_gear")
            }
          )
        }
      }
      .padding(.horizontal, 24)
      .padding(.top, 16)
      .padding(.bottom, 24)
      
      ScrollView(.vertical, showsIndicators: false) {
        ZStack {
          WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationLink(
              isActive: viewStore.binding(
                get: \.showNotice,
                send: MyPageCore.Action._presentNotice
              )
            ) {
              NoticeScene(
                store: self.store.scope(
                  state: \.noticeState,
                  action: MyPageCore.Action.noticeAction
                )
              )
            } label: {
              EmptyView()
            }
          }
          
          VStack(spacing: 24) {
            WithViewStore(store, observe: { $0 }) { viewStore in
              NavigationLink(
                destination: IfLetStore(
                  store.scope(
                    state: \.profileEditState,
                    action: MyPageCore.Action.profileEditAction
                  )
                ) { store in
                  ProfileSettingScene(store: store)
                } else: {
                  EmptyView()
                },
                isActive: viewStore.binding(
                  get: \.presentProfileEdit,
                  send: MyPageCore.Action._presentProfileEdit
                ),
                label: {
                  UserProfileSection(
                    store: store.scope(
                      state: \.profileState,
                      action: MyPageCore.Action.userProfileAction
                    )
                  )
                }
              )
            }
            .buttonStyle(.plain)
            
            VStack(spacing: 12) {
              Section(header: sectionHeaderView(title: "챌린지 현황")) {
                ChallengeStatisticSection()
              }
            }
            
            VStack(spacing: 12) {
              Section(header: sectionHeaderView(title: "고객 지원")) {
                CustomServiceSection(store: store)
              }
            }
          }
          
          Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
      }
    }
    .shareSheet(
      ViewStore(store, observe: { $0 })
        .binding(get: \.shareItem, send: MyPageCore.Action._presentShare)
    )
    .sheet(
      isPresented: ViewStore(store, observe: { $0 })
        .binding(
          get: \.showMail,
          send: MyPageCore.Action._presentMail
        )
    ) {
      EmailSendView()
    }
  }
}

struct CustomServiceSection: View {
  @Environment(\.openURL) var openURL
  let store: StoreOf<MyPageCore>
  
  @ViewBuilder
  private func customServiceCell(to service: CustomerServiceType) -> some View {
    HStack(spacing: 12) {
      Image(service.iconName)
      
      Text(service.description)
      
      Spacer()
    }
    .font(.pretendard(size: 16, weight: .semiBold))
    .padding(16)
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: .zero) {
        ForEach(viewStore.customServices, id: \.rawValue) { service in
          VStack(spacing: .zero) {
            if service == .notice {
              NavigationLink {
                NoticeScene(
                  store: store.scope(
                    state: \.noticeState,
                    action: MyPageCore.Action.noticeAction
                  )
                )
              } label: {
                customServiceCell(to: service)
              }
            } else {
              Button {
                if service == .review {
                  guard let url = URL(string: "https://apps.apple.com/us/app/igomoney/id6467229873") else {
                    return
                  }
                  openURL.callAsFunction(url)
                  return
                }
                
                if service == .inquiry {
                  if MFMailComposeViewController.canSendMail() {
                    viewStore.send(.tapService(service))
                    return
                  }
                  
                  return
                }
              } label: {
                customServiceCell(to: service)
              }
            }
            
            Divider()
          }
          .buttonStyle(.plain)
        }
      }
    }
  }
}

#Preview {
  NavigationView {
    MyPageScene(
      store: Store(
        initialState: MyPageCore.State(),
        reducer: { MyPageCore() }
      )
    )
    .navigationBarHidden(true)
  }
  .navigationViewStyle(.stack)
}
