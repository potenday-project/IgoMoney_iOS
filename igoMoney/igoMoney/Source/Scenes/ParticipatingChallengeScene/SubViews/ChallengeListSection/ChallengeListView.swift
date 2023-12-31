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
    var record: ChallengeRecord
    var isMine: Bool = false
    
    var thumbnailImageState: URLImageCore.State
    var imageStates: IdentifiedArrayOf<URLImageCore.State>
    var title: String
    var content: String
    var cost: Int
    
    var isEditable: Bool = false
    var selectedIndex: Int = .zero
    var deleteAlertState: IGOAlertCore.State = .init()
    
    var id: Int {
      return record.ID
    }
    
    init(record: ChallengeRecord, isMine: Bool) {
      self.record = record
      self.isMine = isMine
      
      let paths = record.imagePath.map { URLImageCore.State(urlPath: $0) }
      self.imageStates = IdentifiedArray(uniqueElements: paths)
      self.thumbnailImageState = URLImageCore.State(urlPath: record.imagePath.first)
      
      self.title = record.title
      self.content = record.content
      self.cost = record.cost
    }
  }
  
  enum Action: Equatable {
    case onAppear
    case onChangeImage(String)
    case onChangeEditable(Bool)
    case onChangeTitle(String)
    case onChangeContent(String)
    case didFinishUpdateContent
    case updateContent
    case showDeclarationView(Bool)
    case showDeleteRecord(Bool)
    case deleteRecord
    
    case onDisappear
    
    case _reloadItem
    case _reloadItemResponse(TaskResult<ChallengeRecord>)
    case updateContentResponse(TaskResult<Data>)
    case _deleteContentResponse(TaskResult<Data>)
    
    case thumbnailImageAction(URLImageCore.Action)
    case urlImageAction(String, URLImageCore.Action)
    case alertAction(IGOAlertCore.Action)
  }
  
  @Dependency(\.recordClient) var recordClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.thumbnailImageState, action: /Action.thumbnailImageAction) {
      URLImageCore()
    }
    
    Scope(state: \.deleteAlertState, action: /Action.alertAction) {
      IGOAlertCore()
    }
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        print("LIST CELL ONAPPEAR \(state.thumbnailImageState)")
        return .send(.thumbnailImageAction(.fetchURLImage))
        
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
        
      case .onChangeImage(let id):
        if let imageIndex = state.imageStates.ids.enumerated()
          .filter({ $0.element == id }).map(\.offset).first {
            state.selectedIndex = imageIndex + 1
          }
          
        return .none
        
      case .onDisappear:
        return .none
        
      case .updateContent:
        let images = state.imageStates.elements.compactMap { $0.image?.pngData() }
        
        let request = RecordRequest(
          challengeID: state.record.ID,
          userID: state.record.userID,
          title: state.title,
          content: state.content,
          cost: state.cost.description,
          images: images
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
        
      case .showDeleteRecord(true):
        return .send(.alertAction(.present))
        
      case .showDeleteRecord(false):
        return .send(.alertAction(.dismiss))
        
      case .deleteRecord:
        return .run { [id = state.record.ID] send in
          await send(
            ._deleteContentResponse(
              TaskResult {
                try await recordClient.deleteRecord(id)
              }
            )
          )
        }
        
      case .showDeclarationView(true):
        return .none
        
      case .showDeclarationView(false):
        return .none
        
      case .updateContentResponse(.success):
        return .send(._reloadItem)
        
      case .updateContentResponse(.failure):
        return .none
        
      case ._reloadItem:
        return .run { [id = state.record.ID] send in
          await send(
            ._reloadItemResponse(
              TaskResult {
                try await recordClient.fetchRecord(id)
              }
            )
          )
        }
        
      case ._reloadItemResponse(.success(let record)):
        state.record = record
        state.title = record.title
        state.content = record.content
        state.content = record.content
        state.cost = record.cost
        return .send(.urlImageAction("", ._setURLPath(record.imagePath.first)))
        
      case ._reloadItemResponse(.failure):
        return .none
        
      case ._deleteContentResponse(.success):
        return .send(.onDisappear)
        
      case ._deleteContentResponse(.failure):
        return .none
        
      case .alertAction:
        return .none
        
      case .thumbnailImageAction:
        return .none
      }
    }
    .forEach(\.imageStates, action: /Action.urlImageAction) {
      URLImageCore()
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
            state: \.thumbnailImageState,
            action: ChallengeRecordDetailCore.Action.thumbnailImageAction
          )
        )
        .scaledToFill()
        .frame(width: 65, height: 65)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        VStack(alignment: .leading, spacing: 4) {
          Text(viewStore.title)
            .lineLimit(1)
            .font(.pretendard(size: 16, weight: .bold))
          
          Text(viewStore.content)
            .lineLimit(1)
            .font(.pretendard(size: 12, weight: .medium))
            .foregroundColor(ColorConstants.gray)
          
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
