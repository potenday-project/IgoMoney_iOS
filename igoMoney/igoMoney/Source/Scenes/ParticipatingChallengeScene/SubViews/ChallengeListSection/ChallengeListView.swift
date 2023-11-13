//
//  ChallengeListView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeListView: View {
  let store: StoreOf<ChallengeRecordSectionCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 12) {
        ForEachStore(
          store.scope(
            state: \.records,
            action: ChallengeRecordSectionCore.Action.challengeRecordAction
          )
        ) { store in
          ChallengeRecordCell(store: store)
            .igoAlert(
              self.store.scope(
                state: \.alertState,
                action: ChallengeRecordSectionCore.Action.alertAction
              )
            ) {
              ChallengeDetailDialog(store: store)
            }
        }
      }
    }
  }
}

struct ChallengeRecordDetailCore: Reducer {
  struct State: Equatable, Identifiable {
    let record: ChallengeRecord
    var imageState: URLImageCore.State
    let title: String
    let content: String
    let cost: Int
    
    var id: Int {
      return record.ID
    }
    
    init(record: ChallengeRecord) {
      self.record = record
      self.imageState = URLImageCore.State(urlPath: record.imagePath)
      self.title = record.title
      self.content = record.content
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
