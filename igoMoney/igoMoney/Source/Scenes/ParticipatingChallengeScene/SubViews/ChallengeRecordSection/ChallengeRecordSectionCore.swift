//
//  ChallengeRecordListCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation


import ComposableArchitecture

struct ChallengeRecordSectionCore: Reducer {
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
    var createChallengeState: CreateChallengeRecordCore.State? = nil
    
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
    case onTapSelectRecord(recordID: Int)
    
    case fetchRecords
    
    case _presentRecordDialog(ChallengeRecordDetailCore.State)
    case _fetchRecordsResponse(TaskResult<[ChallengeRecord]>)
    
    case createChallengeAuthAction(CreateChallengeRecordCore.Action)
    case selectDateAction(RecordSelectDateCore.Action)
    case challengeRecordAction(Int, ChallengeRecordDetailCore.Action)
    case selectedRecordAction(ChallengeRecordDetailCore.Action)
    case alertAction(IGOAlertCore.Action)
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
        let selectedDate = state.selectDateState.selectedDate
        
        if state.selectDateState.isSame {
          state.createChallengeState = CreateChallengeRecordCore.State(
            challenge: challenge,
            selectedDate: selectedDate
          )
          state.isPresentCreate = true
          return .none
        }
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
        
      case let .onTapSelectRecord(recordID):
        guard let record = state.records[id: recordID] else {
          return .none
        }
        
        return .send(._presentRecordDialog(record))
        
      case ._presentRecordDialog:
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
        if records.isEmpty {
          state.records = []
          return .none
        }
        
        state.records.removeAll(where: { $0.record.date != state.selectDateState.selectedDate })
        
        let records = records.filter { $0.isHide == false && $0.date == state.selectDateState.selectedDate }
        
        let decodeRecords = records.map {
          ChallengeRecordDetailCore.State(record: $0, isMine: state.selectedFetchChallenge == .mine)
        }
        
        decodeRecords.forEach { record in
          if state.records.contains(where: { $0.id == record.id }) == false {
            state.records.updateOrAppend(record)
          }
        }
        
        return .none
        
      case ._fetchRecordsResponse(.failure):
        state.records = []
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
        
      case .selectedRecordAction:
        return .none
        
      case .alertAction:
        return .none
      }
    }
    .ifLet(\.createChallengeState, action: /Action.createChallengeAuthAction) {
      CreateChallengeRecordCore()
    }
    .forEach(\.records, action: /Action.challengeRecordAction) {
      ChallengeRecordDetailCore()
    }
  }
}
