//
//  EnterChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct EnterChallengeScene: View {
  let store: StoreOf<EnterChallengeCore>
  
  // 사용자 챌린지 진행 방법 설명
  private enum DuringNotice: Hashable, CaseIterable, CustomStringConvertible {
    case base(index: Int)
    case result
    
    var description: String {
      switch self {
      case .base(let index):
        switch index {
        case 1:
          return "다음날부터 챌린지가 일주일간 진행되요."
        case 2:
          return "매일 내가 지출한 금액과 사진을 인증하세요."
        case 3:
          return "목표 금액을 달성하면 승리합니다."
        case 4:
          return "챌린지에서 이기면 승리 뱃지를 지급해드려요."
        default:
          return ""
        }
      case .result:
        return "모두 목표 금액 달성시, 적게 지출 한쪽이 승리합니다."
      }
    }
    
    var title: String {
      switch self {
      case .base(let index):
        return index.description + "."
      case .result:
        return "•"
      }
    }
    
    static var allCases: [DuringNotice] = [
      .base(index: 1),
      .base(index: 2),
      .base(index: 3),
      .base(index: 4),
      .result
    ]
  }
  // 사용자 챌린지 진행 주의 사항 설명
  private enum Notice: Hashable, CaseIterable, CustomStringConvertible {
    case first
    case second
    case third
    
    var description: String {
      switch self {
      case .first:
        return "하루에 최소 1번 인증샷과 지출 금액을 인증 해야합니다."
      case .second:
        return "인증샷과 지출 금액은 상대방에게 공개됩니다."
      case .third:
        return "챌린지를 포기할 경우 상대방이 승리하게 됩니다."
      }
    }
  }
  
  @ViewBuilder
  func challengeNoticeHeaderView(title: String) -> some View {
    HStack {
      Text(title)
      
      Spacer()
    }
    .font(.pretendard(size: 18, weight: .bold))
  }
  
  var body: some View {
    ZStack {
      VStack {
        IGONavigationBar {
          Text("챌린지 참여하기")
            .font(.pretendard(size: 20, weight: .bold))
        } leftView: {
          Button {
            // TODO: - 뒤로가기 액션 추가하기
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
        
        WithViewStore(store, observe: { $0 }) { viewStore in
          ChallengeInformationCardView(viewStore: viewStore)
        }
        
        VStack(spacing: 16) {
          VStack {
            challengeNoticeHeaderView(title: "📣 챌린지 진행 방법")
            
            VStack(alignment: .leading, spacing: 8) {
              ForEach(DuringNotice.allCases, id: \.self) { notice in
                ChallengeNoticeView(notice: notice.description) {
                  Text(notice.title)
                }
              }
            }
            .font(.pretendard(size: 14, weight: .medium))
            .padding(16)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: ColorConstants.gray2.opacity(0.2), radius: 8, y: 2)
          } // Challenge Doing Information
          
          VStack {
            challengeNoticeHeaderView(title: "📌 챌린지 진행 시 꼭 알아주세요!")
            
            VStack(alignment: .leading, spacing: 8) {
              ForEach(Notice.allCases, id: \.self) { notice in
                ChallengeNoticeView(notice: notice.description) {
                  Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .padding(5)
                }
              }
            }
            .font(.pretendard(size: 14, weight: .medium))
            .padding(16)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: ColorConstants.gray2.opacity(0.2), radius: 8, y: 2)
          } // Challenge Notice Information
          
          Spacer()
          
          Button {
            store.send(.setShowAlert(true))
          } label: {
            HStack {
              Spacer()
              
              Text("챌린지 참여하기")
              
              Spacer()
            }
          } // Enter Button
          .font(.pretendard(size: 18, weight: .medium))
          .foregroundColor(.black)
          .padding(16)
          .background(ColorConstants.primary)
          .cornerRadius(8)
        }
        .padding(24)
        .background(
          Color.white
        )
        .cornerRadius(20, corner: .topLeft)
        .cornerRadius(20, corner: .topRight)
        .edgesIgnoringSafeArea(.bottom)
      }
      
      WithViewStore(store, observe: { $0.showProgressView }) { viewStore in
        if viewStore.state {
          ProgressView()
        }
      }
    }
    .background(
      Color("background_color")
        .edgesIgnoringSafeArea(.all)
    )
    .alert(
      isPresent: ViewStore(store, observe: { $0 })
        .binding(
          get: \.showAlert,
          send: EnterChallengeCore.Action.enterChallenge
        )
    ) {
      IGOAlertView {
        VStack(alignment: .center) {
          Image("icon_hand")
          
          Text("챌린지에\n참가하시겠습니까?")
            .multilineTextAlignment(.center)
            .font(.pretendard(size: 18, weight: .bold))
        }
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
        Text("\(viewStore.challenge.user.nickName)님 챌린지")
          .font(.pretendard(size: 14, weight: .bold))
          .foregroundColor(ColorConstants.gray2)
      
        Spacer()
        
        Text("\(viewStore.challenge.targetAmount)원")
          .padding(.horizontal, 4)
          .font(.pretendard(size: 12, weight: .medium))
          .background(Color.red)
          .cornerRadius(4)
        
        Text("내일 부터 시작")
          .padding(.horizontal, 4)
          .font(.pretendard(size: 12, weight: .medium))
          .background(Color.red)
          .cornerRadius(4)
        
      } // Challenge Information Header
      
      VStack(alignment: .leading, spacing: 8) {
        Text(viewStore.challenge.title)
          .font(.pretendard(size: 18, weight: .bold))
        
        Text(viewStore.challenge.content)
          .font(.pretendard(size: 14, weight: .medium))
      } // Challenge Information Body
    } // Challenge Information Section
    .padding(16)
    .background(ColorConstants.primary7)
    .cornerRadius(10)
    .padding(24)
  }
}

struct ChallengeNoticeView<Sub: View>: View {
  let notice: String
  let subView: () -> Sub
  
  init(notice: String, subView: @escaping () -> Sub) {
    self.notice = notice
    self.subView = subView
  }
  
  var body: some View {
    HStack(alignment: .top) {
      subView()
        .frame(width: 20, height: 20)
      
      Text(notice)
        .lineLimit(2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .minimumScaleFactor(0.5)
    }
  }
}

struct EnterChallengeScene_Previews: PreviewProvider {
  static var previews: some View {
    EnterChallengeScene(
      store: Store(
        initialState: EnterChallengeCore.State(challenge: .default.first!),
        reducer: { EnterChallengeCore() }
      )
    )
  }
}
