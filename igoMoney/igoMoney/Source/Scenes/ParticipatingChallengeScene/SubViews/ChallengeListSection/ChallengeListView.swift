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
            .onTapGesture {
              viewStore.send(.onTapSelectRecord(recordID: store.withState(\.id)))
            }
        }
      }
    }
  }
}

struct ChallengeRecordDetailCore: Reducer {
  struct State: Equatable, Identifiable {
    let record: ChallengeRecord
    var isMine: Bool = false
    
    var imageState: URLImageCore.State
    var title: String
    var content: String
    let cost: Int
    var isEditable: Bool = false
    var selectedIndex: Int = .zero
    
    var id: Int {
      return record.ID
    }
    
    init(record: ChallengeRecord, isMine: Bool) {
      self.record = record
      self.isMine = isMine
      self.imageState = URLImageCore.State(urlPath: record.imagePath.first)
      self.title = record.title
      self.content = record.content
      self.cost = record.cost
    }
  }
  
  enum Action: Equatable {
    case onAppear
    case urlImageAction(URLImageCore.Action)
    case selectImageIndex(Int)
    case onChangeEditable(Bool)
    case onChangeTitle(String)
    case onChangeContent(String)
    case didFinishUpdateContent
    
    case updateContent
    
    case onDisappear
    
    case updateContentResponse(TaskResult<Data>)
  }
  
  @Dependency(\.recordClient) var recordClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.imageState, action: /Action.urlImageAction) {
      URLImageCore()
    }
    
    Reduce {
      state,
      action in
      switch action {
      case .onAppear:
        return .send(.urlImageAction(.fetchURLImage))
        
      case .urlImageAction:
        return .none
        
      case .onChangeEditable(let isEditable):
        if state.isMine == false { return .none }
        
        state.isEditable = isEditable
        return .none
        
      case .onChangeTitle(let title):
        state.title = title
        return .none
        
      case .onChangeContent(let content):
        state.content = content
        return .none
        
      case .didFinishUpdateContent:
        return .concatenate(
          .send(.updateContent),
          .send(.onChangeEditable(false))
        )
        
      case .selectImageIndex(let index):
        state.selectedIndex = index
        return .none
        
      case .onDisappear:
        return .none
        
      case .updateContent:
        guard let imageData = state.imageState.image?.pngData() else { return .none }
        let request = RecordRequest(
          challengeID: state.record.ID,
          userID: state.record.userID,
          title: state.title,
          content: state.content,
          cost: state.cost.description,
          image: imageData
        )
        
        return .run { send in
          await send(
            .updateContentResponse(
              TaskResult {
                try await recordClient.updateRecord(request)
              }
            )
          )
        }
        
      case .updateContentResponse(.success):
        return .none
        
      case .updateContentResponse(.failure(let error)):
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
