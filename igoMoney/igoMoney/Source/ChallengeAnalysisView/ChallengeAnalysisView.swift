//
//  ChallengeAnalysisView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeUserControlView: View {
  private let userCases = UserCase.allCases
  
  private enum UserCase: CaseIterable {
    case me
    case opponent
    
    var description: String {
      switch self {
      case .me: return "나의"
      case .opponent: return "상대방"
      }
    }
  }
  
  var body: some View {
    HStack {
      ForEach(userCases, id: \.self) { userCase in
        Button(action: { }) {
          Text("\(userCase.description)의 챌린지")
        }
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity)
        .overlay(
          Rectangle()
            .frame(height: 1.5),
          alignment: .bottom
        )
        .accentColor(.black)
      }
    }
  }
}

struct UserRecord: Decodable, Identifiable, Equatable {
  var id = UUID()
  let title: String
  let content: String
  let imagePath: String
  let cost: Int
  
  static let `default` = [
    UserRecord(title: "오늘은 도시락을 먹어서 지출은 커피만!", content: "", imagePath: "", cost: 3000),
    UserRecord(title: "오늘은 도시락을 먹어서 지출은 커피만!", content: "", imagePath: "", cost: 2000),
    UserRecord(title: "오늘은 도시락을 먹어서 지출은 커피만!", content: "", imagePath: "", cost: 1000)
  ]
}

struct ChallengeAnalysisCore: Reducer {
  struct State {
    let information: ChallengeInformation
    let records: [UserRecord] = UserRecord.default
  }
  
  enum Action {
    
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

struct ChallengeDateControl: View {
  let dates: [Date]
  
  @ViewBuilder
  private func challengeDateCard(with date: Date, to index: Int) -> some View {
    VStack(spacing: 8) {
      Text(date.toString(with: "MM/dd"))
        .font(.pretendard(size: 12, weight: .medium))
        .frame(maxWidth: .infinity)
      
      Text("\(index + 1)일차")
        .font(.pretendard(size: 14, weight: .semiBold))
        .lineHeight(font: .pretendard(size: 14, weight: .semiBold), lineHeight: 21)
      
      Image(systemName: "checkmark.circle")
        .frame(width: 20, height: 20)
    }
  }
  
  var body: some View {
    HStack(spacing: .zero) {
      ForEach(0..<dates.count, id: \.self) { index in
        let date = dates[index]
        challengeDateCard(with: date, to: index)
          .padding(.vertical, 8)
          .background(ColorConstants.primary6)
          .cornerRadius(8)
      }
    }
  }
}

struct ChallengeAnalysisView: View {
  let store: StoreOf<ChallengeAnalysisCore>
  
  @ViewBuilder
  private func userInputButton() -> some View {
    HStack(alignment: .center) {
      Text("오늘 하루 지출 내역 입력하기")
        .font(.pretendard(size: 16, weight: .bold))
        .lineHeight(font: .pretendard(size: 16, weight: .bold), lineHeight: 23)
        .foregroundColor(.black)
      
      Spacer()
      
      Image("icon_edit")
    } // Input Section
  }
  
  @ViewBuilder
  private func userRecordView(with record: UserRecord) -> some View {
    HStack {
      Image("example_food")
        .resizable()
        .scaledToFill()
        .frame(width: 60, height: 60)
        .cornerRadius(10)
      
      VStack(alignment: .leading, spacing: 4) {
        Text("9월 24일 1일차")
          .font(.pretendard(size: 12, weight: .medium))
        
        Text(record.title)
          .lineLimit(1)
          .font(.pretendard(size: 16, weight: .bold))
        
        Text("\(record.cost) 원")
          .font(.pretendard(size: 12, weight: .medium))
          .lineHeight(font: .pretendard(size: 12, weight: .medium), lineHeight: 16)
          .padding(.horizontal, 4)
          .background(ColorConstants.blue)
          .cornerRadius(4)
      }
      
      Spacer()
    }
  }
  
  var body: some View {
    VStack(spacing: 24) {
      ChallengeUserControlView()
        .font(.pretendard(size: 16, weight: .medium))
      
      VStack(spacing: 12) {
        HStack {
          Text("🔥 9월 24일 일요일 1일차")
          
          Spacer()
        }
        .font(.pretendard(size: 18, weight: .bold))
        
        WithViewStore(store, observe: { $0.information.challengeDateRange }) { viewStore in
          ChallengeDateControl(dates: viewStore.state)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
      }
      
      userInputButton()
        .padding(16)
        .background(ColorConstants.primary8)
        .cornerRadius(10)
        .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
      
      WithViewStore(store, observe: { $0.records }) { viewStore in
        ForEach(viewStore.state, id: \.title) { content in
          userRecordView(with: content)
            .padding(16)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: ColorConstants.gray2.opacity(0.1), radius: 4, y: 2)
        }
      }
      
      Rectangle()
        .fill(.white)
    }
  }
}

struct ChallengeAnalysisView_Previews: PreviewProvider {
  static var previews: some View {
    ChallengeAnalysisView(
      store: Store(
        initialState: ChallengeAnalysisCore.State(
          information: .init(
            title: "일주일에 3만원으로 살아남기",
            content: "",
            targetAmount: .init(money: 30000),
            startDate: Date(),
            user: .default
          )
        ),
        reducer: { ChallengeAnalysisCore() }
      )
    )
    .previewLayout(.sizeThatFits)
  }
}
