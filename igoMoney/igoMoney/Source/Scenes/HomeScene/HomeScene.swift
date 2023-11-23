//
//  ChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct HomeScene: View {
  let store: StoreOf<HomeCore>
  
  @ViewBuilder
  private func titleHeader() -> some View {
    HStack {
      Image("icon_text_main")
        .resizable()
        .scaledToFit()
        .frame(height: 20)
      
      Spacer()
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        NavigationLink(
          isActive: viewStore.binding(
            get: \.showNotificationScene,
            send: HomeCore.Action.showNotificationScene
          )
        ) {
          NotificationScene(
            store: self.store.scope(
              state: \.notificationState,
              action: HomeCore.Action.notificationAction
            )
          )
        } label: {
          Image("icon_notification_fill")
        }
        .buttonStyle(.plain)
      }
    }
    .padding(24)
  }
  
  var body: some View {
    VStack {
      titleHeader()
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 32) {
          MyChallengeSection(
            store: store.scope(
              state: \.myChallengeState,
              action: HomeCore.Action.myChallengeAction
            )
          )
          
          EmptyChallengeListSection(
            store: store.scope(
              state: \.emptyChallengeListState,
              action: HomeCore.Action.emptyChallengeAction
            )
          )
        }
        .padding(24)
        .background(Color.white)
        .padding(.bottom, 80)
      }
      .background(Color.white.edgesIgnoringSafeArea(.all))
      .cornerRadius(20, corner: .topLeft)
      .cornerRadius(20, corner: .topRight)
    }
    .background(
      Color("background_color")
        .edgesIgnoringSafeArea(.top)
    )
    .navigationBarTitle("")
    .navigationBarHidden(true)
  }
}

extension HomeScene {
  enum Section {
    case myChallenge
    case emptyChallenge
    
    var title: String {
      switch self {
      case .myChallenge:
        return "🔥 참여중인 챌린지"
      case .emptyChallenge:
        return "📣 대기중인 챌린지"
      }
    }
    
    var detail: String? {
      switch self {
      case .myChallenge:
        return nil
      case .emptyChallenge:
        return "도전하고 싶은 챌린지를 선택하세요."
      }
    }
    
    var hasButton: Bool {
      return self == .emptyChallenge
    }
  }
}

struct ChallengeSectionTitleView: View {
  let sectionType: HomeScene.Section
  let buttonAction: (() -> Void)?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(sectionType.title)
          .font(.system(size: 20, weight: .bold))
        
        Spacer()
        
        if sectionType.hasButton {
          Button {
            buttonAction?()
          } label: {
            Image(systemName: "chevron.right")
              .resizable()
              .scaledToFit()
              .frame(width: 10, height: 20)
          }
          .accentColor(.black)
        }
      }
      
      if let detail = sectionType.detail {
        Text(detail)
          .font(.pretendard(size: 14, weight: .medium))
          .foregroundColor(ColorConstants.gray)
          .lineHeight(font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
      }
    }
  }
}

struct ChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    HomeScene(
      store: Store(
        initialState: HomeCore.State(),
        reducer: { HomeCore() }
      )
    )
  }
}
