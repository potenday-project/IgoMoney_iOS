//
//  ChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeScene: View {
  let store: StoreOf<ChallengeCore>
  
  @ViewBuilder
  var titleHeader: some View {
    HStack {
      Image("icon_text_main")
        .resizable()
        .scaledToFit()
        .frame(height: 20)
      
      Spacer()
    }
    .padding(24)
  }
  
  var body: some View {
    VStack {
      titleHeader
      
      VStack {
        ScrollView(showsIndicators: false) {
          VStack(spacing: 16) {
            MyChallengeSection(
              store: store.scope(
                state: \.myChallengeState,
                action: ChallengeCore.Action.myChallengeAction
              )
            )
            
            EmptyChallengeListSection(
              store: store.scope(
                state: \.emptyChallengeListState,
                action: ChallengeCore.Action.emptyChallengeAction
              )
            )
          }
          .padding([.horizontal, .top], 24)
          .padding(.bottom, 28)
        }
      }
      .background(Color.white)
      .cornerRadius(20, corner: .topLeft)
      .cornerRadius(20, corner: .topRight)
    }
    .background(
      Color("background_color")
        .edgesIgnoringSafeArea(.top)
    )
  }
}

extension ChallengeScene {
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
        return "내가 도전하고 싶은 챌린지를 선택하세요."
      }
    }
    
    var hasButton: Bool {
      return self == .emptyChallenge
    }
  }
}

struct ChallengeSectionTitleView: View {
  let sectionType: ChallengeScene.Section
  let buttonAction: (() -> Void)?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack {
        Text(sectionType.title)
          .font(.system(size: 30, weight: .bold))
        
        Spacer()
        
        if sectionType.hasButton {
          // TODO: - Button 생성
          Button {
            buttonAction?()
          } label: {
            Image(systemName: "chevron.right")
              .resizable()
              .scaledToFit()
              .frame(width: 24, height: 24)
          }
          
        }
      }
      
      if let detail = sectionType.detail {
        Text(detail)
          .font(.system(size: 14, weight: .medium))
      }
    }
  }
}

struct ChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    ChallengeScene(
      store: Store(
        initialState: ChallengeCore.State(),
        reducer: { ChallengeCore() }
      )
    )
  }
}
