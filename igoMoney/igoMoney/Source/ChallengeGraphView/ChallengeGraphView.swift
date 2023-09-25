//
//  ChallengeGraphView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeGraphCardCore: Reducer {
  struct State: Equatable {
    let information: ChallengeInformation
    let challengeCost: Int
    
    var costRatio: Double {
      return 0.1
    }
  }
  
  enum Action: Equatable {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

struct ChallengeGraphCardView: View {
  let store: StoreOf<ChallengeGraphCardCore>
  
  var body: some View {
    VStack(spacing: 8) {
      HStack(alignment: .bottom) {
        WithViewStore(store, observe: { $0.information }) { viewStore in
          Text(viewStore.user.nickName ?? "")
            .font(.pretendard(size: 16, weight: .bold))
        }
        
        Spacer()
        
        WithViewStore(store, observe: { $0.information }) { viewStore in
          Text("\(viewStore.state.targetAmount.money) 원")
            .font(.pretendard(size: 12, weight: .medium))
            .foregroundColor(ColorConstants.gray2)
        }
      }
      
      WithViewStore(store, observe: { $0 }) { viewStore in
        GeometryReader { proxy in
          RoundedRectangle(cornerRadius: .infinity)
            .fill(ColorConstants.primary6)
            .frame(maxWidth: proxy.frame(in: .local).width, maxHeight: 8)
            .overlay(
              RoundedRectangle(cornerRadius: .infinity)
                .fill(ColorConstants.primary2)
                .frame(maxWidth: proxy.frame(in: .local).width * viewStore.costRatio, maxHeight: 8),
              alignment: .leading
            )
        }
      }
      
      HStack {
        Text("누적 금액")
          .font(.pretendard(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray)
        
        Spacer()
        
        WithViewStore(store, observe: { $0.challengeCost }) { viewStore in
          Text("\(viewStore.state) 원")
            .foregroundColor(ColorConstants.primary2)
            .font(.pretendard(size: 12, weight: .bold))
        }
      }
    }
  }
}

struct ChallengeGraphView: View {
  var body: some View {
    VStack(spacing: 8) {
      ChallengeGraphCardView(
        store: Store(
          initialState: ChallengeGraphCardCore.State(
            information: .init(
              title: "일주일에 3만원으로 살아남기",
              content: "",
              targetAmount: .init(money: 30000),
              user: .default
            ),
            challengeCost: 3000
          ),
          reducer: { ChallengeGraphCardCore()._printChanges() }
        )
      )
      
      Divider()
        .background(ColorConstants.gray4)
      
      ChallengeGraphCardView(
        store: Store(
          initialState: ChallengeGraphCardCore.State(
            information: .init(
              title: "일주일에 3만원으로 살아남기",
              content: "",
              targetAmount: .init(money: 30000),
              user: .default
            ),
            challengeCost: 3000
          ),
          reducer: { ChallengeGraphCardCore() }
        )
      )
      
      Divider()
        .background(ColorConstants.gray4)
      
      Text("현재 오마이머니님이 더 절약하고 있어요 🤔")
        .font(.pretendard(size: 14, weight: .bold))
    }
    .padding(16)
    .background(ColorConstants.primary8)
    .cornerRadius(10)
  }
}

struct ChallengeGraphView_Previews: PreviewProvider {
  static var previews: some View {
    ChallengeGraphCardView(store: Store(
      initialState: ChallengeGraphCardCore.State(
        information: .init(
          title: "일주일에 3만원으로 살아남기",
          content: "",
          targetAmount: .init(money: 30000),
          user: .default
        ),
        challengeCost: 3000
      ),
      reducer: { ChallengeGraphCardCore()._printChanges() })
    )
    .previewLayout(.sizeThatFits)
    
    ChallengeGraphView()
      .previewLayout(.sizeThatFits)
  }
}
