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
      
      WithViewStore(store, observe: { $0.challengeState }) { viewStore in
        switch viewStore.state {
        case .empty:
          MyChallengeBannerView(
            iconName: "plus.circle",
            title: "아직 진행중인 챌린지가 없어요"
          ) {
            Text("아래 챌린지를 선택해보거나 직접 챌린지를 만들어볼까요?")
              .font(.pretendard(size: 12, weight: .medium))
              .lineLimit(1)
              .minimumScaleFactor(0.8)
          }
          
        case .waiting:
          MyChallengeBannerView(
            subTitle: "🤔",
            title: "챌린지할 상대를 기다리고 있어요!"
          ) {
            HStack(spacing: 4) {
              Text("💸 30000원")
                .font(.pretendard(size: 12, weight: .medium))
                .padding(.horizontal, 4)
                .background(ColorConstants.primary6)
                .cornerRadius(4)
              
              Text("📅 대기중")
                .font(.pretendard(size: 12, weight: .medium))
                .padding(.horizontal, 4)
                .background(ColorConstants.primary6)
                .cornerRadius(4)
            }
          }
        case .challenging:
          MyChallengeBannerView(
            subTitle: "뒷주머니님과 챌린지 완료",
            title: "아이고머니님!챌린지에서 승리하셨어요 🥇"
          ) {
            
            Button(action: { }) {
              Text("확인하기")
            }
            .font(.pretendard(size: 12, weight: .medium))
            .padding(.horizontal, 4)
            .background(ColorConstants.primary6)
            .foregroundColor(.black)
            .cornerRadius(4)
          }
        case .result:
          MyChallengeBannerView(
            subTitle: "내일 부터 뒷주머니님과 챌린지",
            title: "일주일에 3만원으로 살아남기"
          ) {
            HStack(spacing: 4) {
              Text("💸 30000원")
                .font(.pretendard(size: 12, weight: .medium))
                .padding(.horizontal, 4)
                .background(ColorConstants.primary6)
                .cornerRadius(4)
              
              Text("📅 9월 24일 일요일 시작")
                .font(.pretendard(size: 12, weight: .medium))
                .padding(.horizontal, 4)
                .background(ColorConstants.primary6)
                .cornerRadius(4)
            }
          }
        }
      }
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(ColorConstants.primary)
      )
      .onTapGesture {
        store.send(.changeState)
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
          initialState: MyChallengeSectionCore.State(challengeState: .empty),
          reducer: { MyChallengeSectionCore() }
        )
      )
      
      MyChallengeSection(
        store: Store(
          initialState: MyChallengeSectionCore.State(challengeState: .waiting),
          reducer: { MyChallengeSectionCore() }
        )
      )
      
      MyChallengeSection(
        store: Store(
          initialState: MyChallengeSectionCore.State(challengeState: .challenging),
          reducer: { MyChallengeSectionCore() }
        )
      )
      
      MyChallengeSection(
        store: Store(
          initialState: MyChallengeSectionCore.State(challengeState: .result),
          reducer: { MyChallengeSectionCore() }
        )
      )
    }
    .previewLayout(.sizeThatFits)
  }
}
