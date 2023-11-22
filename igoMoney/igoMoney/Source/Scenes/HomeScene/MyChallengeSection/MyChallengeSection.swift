//
//  MyChallengeSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyChallengeSection: View {
  let store: StoreOf<MyChallengeSectionCore>
  
  @ViewBuilder
  func challengeInformationView(to challenge: Challenge) -> some View {
    HStack(spacing: 4) {
      Text(challenge.targetAmount.description)
        .padding(.horizontal, 4)
        .background(
          Color(challenge.targetAmount.colorName)
        )
        .cornerRadius(4)
      
      Text("⏰ \(challenge.startDate?.toString(with: "MM월 dd일 시작") ?? "")")
        .padding(.horizontal, 4)
        .background(ColorConstants.primary6)
        .cornerRadius(4)
    }
    .font(.pretendard(size: 12, weight: .medium))
    .lineHeight(
      font: .pretendard(size: 12, weight: .medium),
      lineHeight: 16
    )
  }
  
  var body: some View {
    VStack {
      ChallengeSectionTitleView(
        sectionType: .myChallenge,
        buttonAction: nil
      )
      
      WithViewStore(store, observe: { $0.userChallenge }) { status in
        switch status.state {
        case .processingChallenge(let challenge):
          NavigationLink {
            IfLetStore(
              store.scope(
                state: \.participatingChallenge,
                action: MyChallengeSectionCore.Action.participatingChallengeAction
              )
            ) { store in
              ParticipatingChallengeScene(store: store)
            }
          } label: {
            MyChallengeBannerView(title: challenge.title) {
              challengeInformationView(to: challenge)
            }
          }
          .buttonStyle(.plain)
          
        case .waitingUser(let challenge):
          MyChallengeBannerView(
            subTitle: "🤔",
            title: "챌린지할 상대를 기다리고 있어요!"
          ) {
            challengeInformationView(to: challenge)
          }
          
        case .waitingStart(let challenge):
          MyChallengeBannerView(
            subTitle: "챌린지 시작 대기중",
            title: challenge.title
          ) {
            challengeInformationView(to: challenge)
          }
          
        case .notInChallenge:
          MyChallengeBannerView(
            iconName: "plus.circle",
            title: "아직 진행중인 챌린지가 없어요"
          ) {
            Text("아래 챌린지를 선택해보거나 직접 챌린지를 만들어볼까요?")
              .font(.pretendard(size: 12, weight: .medium))
              .lineLimit(1)
              .minimumScaleFactor(0.8)
          }
        }
      }
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(ColorConstants.primary)
      )
      .onAppear {
        store.send(._onAppear)
      }
    }
  }
}

struct MyChallengeBannerView<B: View>: View {
  var iconName: String? = nil
  var subTitle: String? = nil
  var title: String
  var bodyView: B
  
  init(
    iconName: String? = nil,
    subTitle: String? = nil,
    title: String,
    bodyView: () -> B
  ) {
    self.iconName = iconName
    self.subTitle = subTitle
    self.title = title
    self.bodyView = bodyView()
  }
  var body: some View {
    IGOBannerView(
      topView: {
        VStack {
          if let iconName = iconName {
            Image(systemName: iconName)
              .font(.pretendard(size: 16, weight: .bold))
              .foregroundColor(ColorConstants.primary)
          } else if let subTitle = subTitle {
            Text(subTitle)
              .font(.pretendard(size: 12, weight: .medium))
              .lineLimit(1)
              .foregroundColor(ColorConstants.gray2)
          } else {
            EmptyView()
          }
        }
      }, middleView: {
        Text(title)
          .lineLimit(1)
          .minimumScaleFactor(0.8)
          .font(.pretendard(size: 18, weight: .bold))
      }, bottomView: {
        bodyView
      }
    )
  }
}

struct MyChallengeSection_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MyChallengeSection(
        store: Store(
          initialState: MyChallengeSectionCore.State(
            userChallenge: .waitingStart(.default)
          ),
          reducer: { MyChallengeSectionCore() }
        )
      )
    }
    .previewLayout(.sizeThatFits)
  }
}
