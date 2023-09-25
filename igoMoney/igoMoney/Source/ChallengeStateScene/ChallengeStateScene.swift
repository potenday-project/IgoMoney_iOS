//
//  ChallengeStateScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeInformationDetailView: View {
  let store: StoreOf<ChallengeDetailCore>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack {
        WithViewStore(store, observe: { $0 }) { viewStore in
          Text(viewStore.user.nickName + "님과 대결중")
            .font(.pretendard(size: 14, weight: .bold))
            .foregroundColor(ColorConstants.gray2)
        }
        
        Spacer()
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          Text(viewStore.targetAmount.description)
            .font(.pretendard(size: 12, weight: .medium))
            .padding(.horizontal, 4)
            .background(Color(viewStore.targetAmount.colorName))
            .cornerRadius(4)
        }
      }
      .padding(.horizontal, 16)
      .padding(.top, 16)
      
      HStack {
        WithViewStore(store, observe: { $0 }) { viewStore in
          Text(viewStore.title)
            .font(.pretendard(size: 16, weight: .bold))
        }
        
        Spacer()
      }
      .padding(.horizontal, 16)
      .padding(.bottom, 16)
    }
    .background(Color.white)
    .cornerRadius(10)
  }
}

struct ChallengeStateScene: View {
  var body: some View {
    ZStack {
      Color.white.edgesIgnoringSafeArea(.all)
      
      VStack(spacing: .zero) {
        IGONavigationBar {
          EmptyView()
        } leftView: {
          Text("참여중인 챌린지")
            .font(.pretendard(size: 20, weight: .bold))
            .foregroundColor(.white)
        } rightView: {
          Button(action: { }) {
            Text("대결 포기하기")
          }
          .font(.pretendard(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray4)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .padding(.top, 32)
        .background(Color("background_color"))
        
        ScrollView(showsIndicators: false) {
          VStack(spacing: 16) {
            ChallengeInformationDetailView(
              store: Store(
                initialState: ChallengeDetailCore.State(
                  id: UUID(),
                  title: "일주일에 3만원으로 살아남기",
                  content: "",
                  targetAmount: .init(money: 30000),
                  user: .default
                ), reducer: {
                  ChallengeDetailCore()
                }
              )
            )
            .padding(.horizontal, 24)
            .background(Color("background_color"))
            
            ChallengeGraphView()
              .padding(.horizontal, 24)
              .background(Color("background_color"))
            
            ChallengeAnalysisView(
              store: Store(
                initialState: ChallengeAnalysisCore.State(
                  information: .init(
                    title: "일주일에 3만원으로 살아남기",
                    content: "",
                    targetAmount: .init(money: 30000),
                    user: .default
                  )
                ), reducer: {
                  ChallengeAnalysisCore()
                }
              )
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(10, corner: .topLeft)
            .cornerRadius(10, corner: .topRight)
          }
          .background(Color("background_color"))
          .edgesIgnoringSafeArea(.bottom)
        }
        .background(
          VStack {
            Rectangle()
              .fill(Color("background_color"))
              .frame(height: 300)
            
            Spacer()
          }
        )
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}
struct ChallengeStateScene_Previews: PreviewProvider {
  static var previews: some View {
    ChallengeStateScene()
  }
}
