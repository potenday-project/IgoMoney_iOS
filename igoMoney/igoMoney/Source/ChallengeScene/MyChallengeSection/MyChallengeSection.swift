//
//  MyChallengeSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MyChallengeSection: View {
  let store: StoreOf<MyChallengeSectionCore>
  // TODO: - 섹션 reducer 연결하기
  var body: some View {
    VStack {
      ChallengeSectionTitleView(
        sectionType: .myChallenge,
        buttonAction: nil
      )
      
      WithViewStore(store, observe: { $0.currentChallengeState }) { viewStore in
        if let challenge = viewStore.state { // 참가중인 챌린지 있는 경우
          MyChallengeBannerView(
            subTitle: "뒷주머니님과 챌린지 중", 
            title: challenge.title
          ) {
            HStack(spacing: 4) {
              Text(challenge.targetAmount.description)
                .font(.pretendard(size: 12, weight: .medium))
                .lineHeight(
                  font: .pretendard(size: 12, weight: .medium),
                  lineHeight: 16
                )
                .padding(.horizontal, 4)
                .background(
                  Color(challenge.targetAmount.colorName)
                )
                .cornerRadius(4)
              
              if let challengeDate = challenge.startDate {
                Text("📅 \(challengeDate.toString(with: "M월 dd일"))")
                  .font(.pretendard(size: 12, weight: .medium))
                  .lineHeight(
                    font: .pretendard(size: 12, weight: .medium),
                    lineHeight: 16
                  )
                  .padding(.horizontal, 4)
                  .background(ColorConstants.primary6)
                  .cornerRadius(4)
              }
            }
          }
        } else { // 참가중인 챌린지가 없는 경우
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
              .minimumScaleFactor(0.8)
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
          initialState: MyChallengeSectionCore.State(),
          reducer: { MyChallengeSectionCore() }
        )
      )
      
      MyChallengeSection(
        store: Store(
          initialState: MyChallengeSectionCore.State(
            currentChallengeState: .default
          ),
          reducer: { MyChallengeSectionCore() }
        )
      )
    }
    .previewLayout(.sizeThatFits)
  }
}
