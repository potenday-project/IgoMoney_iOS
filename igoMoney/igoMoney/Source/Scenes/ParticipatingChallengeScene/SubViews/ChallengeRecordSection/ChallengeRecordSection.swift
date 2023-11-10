//
//  CertifiedArticleSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeRecordSection: View {
  @ViewBuilder
  private func ChallengeClassificationButton(
    title: String,
    isSelected: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button {
      action()
    } label: {
      Text(title)
        .padding(.vertical, 8)
    }
    .buttonStyle(.plain)
    .foregroundColor(isSelected ? Color.black : ColorConstants.gray3)
    .frame(maxWidth: .infinity)
    .overlay(
      Rectangle()
        .frame(height: 1.5)
        .foregroundColor(isSelected ? Color.black : ColorConstants.gray3)
      , alignment: .bottom
    )
  }
  
  let store: StoreOf<ChallengeRecordSectionCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        Color.white.edgesIgnoringSafeArea(.all)
          .ignoresSafeArea()
        
        VStack(spacing: 24) {
          HStack(spacing: 16) {
            ChallengeClassificationButton(
              title: "나의 챌린지",
              isSelected: viewStore.selectedFetchChallenge == .mine
            ) {
              viewStore.send(.toggleSelect(.mine))
            }
            
            ChallengeClassificationButton(
              title: "상대방 챌린지",
              isSelected: viewStore.selectedFetchChallenge == .competitor
            ) {
              viewStore.send(.toggleSelect(.competitor))
            }
          }
          .padding(.top, 20)
          .font(.pretendard(size: 16, weight: .bold))
          
          RecordDateSelectView(
            store: self.store.scope(
              state: \.selectDateState,
              action: ChallengeRecordSectionCore.Action.selectDateAction
            )
          )
          
          ChallengeListView(store: self.store)
          
          Spacer()
        }
        .padding(.horizontal, 24)
      }
      .fullScreenCover(
        isPresented: viewStore.binding(
          get: \.isPresentCreate,
          send: ChallengeRecordSectionCore.Action.presentCreate
        )
      ) {
        IfLetStore(
          store.scope(
            state: \.createChallengeState,
            action: ChallengeRecordSectionCore.Action.createChallengeAuthAction
          )
        ) { store in
          CreateChallengeRecordScene(store: store)
        }
      }
    }
  }
}

struct RecordSelectDateCore: Reducer {
  struct State: Equatable {
    let startDate: Date
    var selectedDate: Date = Date()
    var rangeOfChallengeDate: [Date] {
      let valueRange = (0...6)
      let calendar = Calendar.current
      let days = valueRange.map {
        return calendar.date(byAdding: .day, value: $0, to: startDate) ?? Date()
      }
      return days
    }
    
    var differenceOfStartDate: Int {
      let difference = Calendar.current.dateComponents([.day], from: startDate, to: selectedDate).day
      return (difference ?? .zero) + 1
    }
    
    var isSame: Bool {
      return selectedDate == Date()
    }
  }
  
  enum Action: Equatable {
    case selectDate(Date)
    case presentCreateRecord(Bool)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .selectDate(let date):
        state.selectedDate = date
        return .none
        
      case .presentCreateRecord:
        return .none
      }
    }
  }
}

struct RecordDateSelectView: View {
  let store: StoreOf<RecordSelectDateCore>
  @ViewBuilder
  private func DateSelectButton(index: Int, to date: Date) -> some View {
    VStack(spacing: 8) {
      Text(date.toString(with: "M/dd"))
        .font(.pretendard(size: 12, weight: .medium))
      
      Text((index + 1).description + "일차")
        .font(.pretendard(size: 14, weight: .semiBold))
      
      Image(systemName: "checkmark.circle")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
    }
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      
      VStack(spacing: 12) {
        HStack {
          Text("🔥 \(viewStore.selectedDate.toString(with: "MM월 d일 EE요일")) \(viewStore.differenceOfStartDate)일차")
          
          Spacer()
        }
        .font(.pretendard(size: 18, weight: .bold))
      }
      
      HStack(spacing: .zero) {
        ForEach(0..<viewStore.rangeOfChallengeDate.count, id: \.self) { index in
          let date = viewStore.rangeOfChallengeDate[index]
          ZStack {
            if viewStore.selectedDate == date {
              RoundedRectangle(cornerRadius: 8)
                .fill(ColorConstants.primary7)
                .transition(.scale)
            }
            
            DateSelectButton(index: index, to: date)
              .padding(.vertical, 8)
          }
          .frame(maxWidth: .infinity, maxHeight: 100)
          .onTapGesture {
            viewStore.send(.selectDate(date), animation: .easeInOut)
          }
        }
        
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(Color.white)
      .cornerRadius(8)
      .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
      
      
      CertifyButton(selectedDate: viewStore.selectedDate) {
        viewStore.send(.presentCreateRecord(true))
      }
    }
  }
}

struct CertifyButton: View {
  let selectedDate: Date
  let action: () -> Void
  
  var body: some View {
    Button {
      action()
    } label: {
      HStack {
        VStack(alignment: .leading, spacing: .zero) {
          Text(selectedDate.toString(with: "M월 dd일"))
            .font(.pretendard(size: 12, weight: .medium))
          
          Text("오늘 하루 지출 내역 인증하기")
            .font(.pretendard(size: 16, weight: .bold))
        }
        
        Spacer()
        
        Image("icon_add_task")
      }
    }
    .buttonStyle(.plain)
    .padding(16)
    .background(ColorConstants.primary8)
    .cornerRadius(10)
    .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
  }
}
