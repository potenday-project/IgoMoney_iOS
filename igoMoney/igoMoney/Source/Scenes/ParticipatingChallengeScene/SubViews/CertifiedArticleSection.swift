//
//  CertifiedArticleSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeAuthListCore: Reducer {
  enum FetchChallengeCase {
    case mine
    case competitor
  }
  struct State: Equatable {
    var selectedFetchChallenge: FetchChallengeCase = .mine
    let challenge: Challenge
    var currentUserID: Int? = nil
    var competitorUserID: Int? = nil
    var selectDateState: RecordSelectDateCore.State
    var records: IdentifiedArrayOf<ChallengeRecordDetailCore.State> = []
    
    var isPresentCreate: Bool = false
    var createChallengeState: CreateChallengeAuthCore.State? = nil
    
    init(challenge: Challenge) {
      self.challenge = challenge
      let date = challenge.startDate ?? Date()
      self.selectDateState = RecordSelectDateCore.State(startDate: date)
    }
  }
  
  enum Action: Equatable {
    case toggleSelect(FetchChallengeCase)
    case presentCreate(Bool)
    case setCurrentUserID(userID: Int)
    case setCompetitorID(userID: Int)
    
    case fetchRecords
    
    case _fetchRecordsResponse(TaskResult<[ChallengeRecord]>)
    
    case createChallengeAuthAction(CreateChallengeAuthCore.Action)
    case selectDateAction(RecordSelectDateCore.Action)
    case challengeRecordAction(Int, ChallengeRecordDetailCore.Action)
  }
  
  @Dependency(\.recordClient) var recordClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.selectDateState, action: /Action.selectDateAction) {
      RecordSelectDateCore()
    }
    
    Reduce { state, action in
      switch action {
      case .toggleSelect(let fetchType):
        state.selectedFetchChallenge = fetchType
        return .send(.fetchRecords)
        
      case .presentCreate(true):
        let challenge = state.challenge
        state.createChallengeState = CreateChallengeAuthCore.State(challenge: challenge)
        state.isPresentCreate = true
        return .none
        
      case .presentCreate(false):
        state.createChallengeState = nil
        state.isPresentCreate = false
        return .none
        
      case let .setCurrentUserID(userID):
        state.currentUserID = userID
        return .none
        
      case let .setCompetitorID(userID):
        state.competitorUserID = userID
        return .none
        
      case .fetchRecords:
        let userID = state.selectedFetchChallenge == .mine ? state.currentUserID : state.competitorUserID
        guard let userID = userID else {
          return .none
        }
        
        return .run { [selectedDate = state.selectDateState.selectedDate] send in
          await send(
            ._fetchRecordsResponse(
              TaskResult {
                try await recordClient.fetchAllRecord(selectedDate, userID)
              }
            )
          )
        }
        
      case ._fetchRecordsResponse(.success(let records)):
        let decodeRecords = records.map { ChallengeRecordDetailCore.State(record: $0) }
        state.records = IdentifiedArray(uniqueElements: decodeRecords)
        return .none
        
      case ._fetchRecordsResponse(.failure):
        return .none
        
      case .createChallengeAuthAction(._registerRecordResponse(.success)):
        return .send(.presentCreate(false))
        
      case .createChallengeAuthAction:
        return .none
        
      case .selectDateAction(.selectDate):
        return .send(.fetchRecords)
        
      case .selectDateAction(.presentCreateRecord(true)):
        return .send(.presentCreate(true))
        
      case .selectDateAction:
        return .none
        
      case .challengeRecordAction:
        return .none
      }
    }
    .ifLet(\.createChallengeState, action: /Action.createChallengeAuthAction) {
      CreateChallengeAuthCore()
    }
    .forEach(\.records, action: /Action.challengeRecordAction) {
      ChallengeRecordDetailCore()
    }
  }
}

struct CertifiedArticleSection: View {
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
  
  let store: StoreOf<ChallengeAuthListCore>
  
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
          
          CertifiedDateSelectView(
            store: self.store.scope(
              state: \.selectDateState,
              action: ChallengeAuthListCore.Action.selectDateAction
            )
          )
          
          CertifiedArticleListView(store: self.store)
          
          Spacer()
        }
        .padding(.horizontal, 24)
      }
      .fullScreenCover(
        isPresented: viewStore.binding(
          get: \.isPresentCreate,
          send: ChallengeAuthListCore.Action.presentCreate
        )
      ) {
        IfLetStore(
          store.scope(
            state: \.createChallengeState,
            action: ChallengeAuthListCore.Action.createChallengeAuthAction
          )
        ) { store in
          CreateChallengeAuthScene(store: store)
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

extension Date {
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.toString(with: "yy.MM.dd") == rhs.toString(with: "yy.MM.dd")
  }
}

struct CertifiedDateSelectView: View {
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

struct ChallengeRecordDetailCore: Reducer {
  struct State: Equatable, Identifiable {
    let record: ChallengeRecord
    var imageState: URLImageCore.State
    let title: String
    let cost: Int
    
    var id: Int {
      return record.ID
    }
    
    init(record: ChallengeRecord) {
      self.record = record
      self.imageState = URLImageCore.State(urlPath: record.imagePath)
      self.title = record.title
      self.cost = record.cost
    }
  }
  
  enum Action: Equatable {
    case onAppear
    case urlImageAction(URLImageCore.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.imageState, action: /Action.urlImageAction) {
      URLImageCore()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.urlImageAction(.fetchURLImage))
      case .urlImageAction:
        return .none
      }
    }
  }
}

struct ChallengeRecordCell: View {
  let store: StoreOf<ChallengeRecordDetailCore>
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        URLImage(
          store: store.scope(
            state: \.imageState,
            action: ChallengeRecordDetailCore.Action.urlImageAction
          )
        )
        .scaledToFill()
        .frame(width: 65, height: 65)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        VStack(alignment: .leading, spacing: 4) {
          Text("9월 24일 1일차")
            .font(.pretendard(size: 12, weight: .medium))
            .foregroundColor(ColorConstants.gray3)
          
          Text(viewStore.title)
            .font(.pretendard(size: 16, weight: .bold))
          
          Text("총 \(viewStore.cost)원 지출")
            .font(.pretendard(size: 12, weight: .medium))
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(ColorConstants.blue)
            .cornerRadius(4)
        }
        
        Spacer()
      }
    }
    .padding(16)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
    .onAppear {
      store.send(.onAppear)
    }
  }
}

struct CertifiedArticleListView: View {
  let store: StoreOf<ChallengeAuthListCore>
  
  var body: some View {
    VStack(spacing: 12) {
      ForEachStore(
        store.scope(
          state: \.records,
          action: ChallengeAuthListCore.Action.challengeRecordAction
        )
      ) { store in
        ChallengeRecordCell(store: store)
      }
    }
  }
}
