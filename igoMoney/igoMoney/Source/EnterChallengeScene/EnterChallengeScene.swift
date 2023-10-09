//
//  EnterChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct EnterChallengeScene: View {
  let store: StoreOf<EnterChallengeCore>
  
  @ViewBuilder
  private var navigationSection: some View {
    IGONavigationBar {
      Text("챌린지 참여하기")
        .font(.pretendard(size: 20, weight: .bold))
    } leftView: {
      Button {
        store.send(.dismiss)
      } label: {
        Image(systemName: "chevron.left")
          .font(.pretendard(size: 22, weight: .bold))
      }
    } rightView: {
      EmptyView()
    }
    .padding(.top, 16)
    .foregroundColor(.white)
    .padding(.horizontal, 24)
  }
  
  var body: some View {
    ZStack {
      VStack {
        navigationSection // Navigation Section
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          ChallengeInformationCardView(viewStore: viewStore)
        } // Information Section
        
        VStack(spacing: 16) {
          VStack {
            ChallengeNoticeView()
            
            Spacer()
            
            WithViewStore(store, observe: { $0 }) { viewStore in
              Button(action: {
                viewStore.send(.setShowAlert(true))
              }) {
                Text("챌린지 참가하기")
              }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .font(.pretendard(size: 18, weight: .medium))
            .foregroundColor(.black)
            .background(ColorConstants.primary)
            .cornerRadius(8)
          }
          .padding(24)
          .background(Color.white)
          .cornerRadius(20, corner: .topLeft)
          .cornerRadius(20, corner: .topRight)
        } // Main Section
        .edgesIgnoringSafeArea(.bottom)
      }
      .onAppear {
        store.send(._onAppear)
      }
      .background(
        Color("background_color")
          .edgesIgnoringSafeArea(.top)
      )
      .alert(
        isPresent: ViewStore(store, observe: { $0 })
          .binding(
            get: \.showAlert,
            send: EnterChallengeCore.Action.enterChallenge
          )
      ) {
        IGOAlertView {
          Text("챌린지에 참가하시겠습니까?")
            .multilineTextAlignment(.center)
            .font(.pretendard(size: 18, weight: .bold))
        } primaryButton: {
          IGOAlertButton(
            title: Text("네").foregroundColor(Color.black),
            color: ColorConstants.primary
          ) {
            store.send(.enterChallenge)
          }
        } secondaryButton: {
          IGOAlertButton(
            title: Text("아니요").foregroundColor(ColorConstants.gray3),
            color: ColorConstants.gray5
          ) {
            store.send(.setShowAlert(false))
          }
        }
      }
      .navigationBarHidden(true)
    }
  }
  
  struct ChallengeInformationCardView: View {
    let viewStore: ViewStoreOf<EnterChallengeCore>
    
    var body: some View {
      VStack(alignment: .leading, spacing: 8) {
        
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("\(viewStore.leader?.nickName ?? "")님과 챌린지")
              .font(.pretendard(size: 14, weight: .bold))
              .foregroundColor(ColorConstants.gray2)
            
            Text(viewStore.challenge.title)
              .font(.pretendard(size: 18, weight: .bold))
              .lineLimit(1)
            
            HStack {
              Text(viewStore.challenge.targetAmount.description)
                .padding(.horizontal, 4)
                .font(.pretendard(size: 12, weight: .medium))
                .background(Color(viewStore.challenge.targetAmount.colorName))
                .cornerRadius(4)
              
              Text("⏰ 내일 부터 시작")
                .padding(.horizontal, 4)
                .font(.pretendard(size: 12, weight: .medium))
                .background(ColorConstants.primary7)
                .cornerRadius(4)
            }
          }
          
          Spacer()
          
          Image("default_profile")
            .resizable()
            .scaledToFill()
            .frame(width: 50, height: 50)
        }
        
        Text(viewStore.challenge.content)
          .font(.pretendard(size: 14, weight: .medium))
      } // Challenge Information Section
      .padding(16)
      .background(Color.white)
      .cornerRadius(10)
      .padding(24)
    }
  }
  
  struct ChallengeNoticeView: View {
    struct Notice: Hashable {
      let index: Int
      let description: String
      private var icon: String? = nil
      
      var iconName: String {
        if let icon = icon {
          return icon
        } else {
          return "\(index).circle"
        }
      }
      
      static let defaultMethodNotice: [Notice] = [
        .init(index: 1, description: "참가 후 다음날부터 챌린지가 일주일동안 진행되요"),
        .init(index: 2, description: "내가 지출한 금액과 사진을 매일 인증하세요."),
        .init(index: 3, description: "목표 금액을 달성하면 승리합니다."),
        .init(index: 4, description: "챌린지에서 이기면 승리 뱃지가 지급됩니다."),
      ]
      
      static let defaultDuringNotice: [Notice] = [
        .init(index: 1, description: "하루에 최소 1번 인증샷과 지출 금액을 인증해야 합니다.", icon: "checkmark.circle"),
        .init(index: 2, description: "인증샷과 지출 금액은 상대방에게 공개됩니다.", icon: "checkmark.circle"),
        .init(index: 3, description: "챌린지를 포기할 경우 상대방이 승리하게 됩니다.", icon: "checkmark.circle"),
        .init(index: 4, description: "모두 목표 금액 달성 시, 적게 지출 한쪽이 승리합니다.", icon: "checkmark.circle"),
      ]
    }
    
    @ViewBuilder
    private func noticeSectionView(notices: [Notice]) -> some View {
      VStack(alignment: .leading, spacing: 8) {
        ForEach(notices, id: \.index) { notice in
          HStack {
            Image(systemName: notice.iconName)
            
            Text(notice.description)
            
            Spacer()
          }
          .frame(maxWidth: .infinity)
        }
      }
      .font(.pretendard(size: 14, weight: .medium))
      .padding(16)
      .background(Color.white)
      .cornerRadius(10)
      .shadow(color: ColorConstants.gray2.opacity(0.2), radius: 8, y: 2)
    }
    
    var body: some View {
      VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 16) {
          Text("📣 챌린지 진행 방법")
            .font(.pretendard(size: 18, weight: .semiBold))
          
          noticeSectionView(notices: Notice.defaultMethodNotice)
        }
        
        VStack(alignment: .leading, spacing: 16) {
          Text("📌 챌린지 진행 시 꼭 알아주세요!")
            .font(.pretendard(size: 18, weight: .semiBold))
          
          noticeSectionView(notices: Notice.defaultDuringNotice)
        }
      }
    }
  }
}

#Preview {
  EnterChallengeScene(
    store: Store(
      initialState: EnterChallengeCore.State(challenge: .default),
      reducer: { EnterChallengeCore() }
    )
  )
}
