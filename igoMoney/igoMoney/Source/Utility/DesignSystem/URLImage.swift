//
//  URLImage.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import SwiftUI

import ComposableArchitecture

struct URLImageCore: Reducer {
  struct State: Equatable {
    var urlPath: String?
    var loadingStatus: LoadingState = .initial
  }
  
  enum LoadingState: Equatable {
    case initial
    case inProgress
    case success(_ image: Image)
    case failure
  }
  
  enum Action: Equatable {
    case onAppear
    
    case fetchURLImage
    case _fetchURLImageResponse(TaskResult<Image>)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      state.loadingStatus = .inProgress
      return .send(.fetchURLImage)
      
    case .fetchURLImage:
      guard let path = state.urlPath, let url = URL(string: path) else {
        state.loadingStatus = .failure
        return .none
      }
      
      return .run { send in
        await send(
          ._fetchURLImageResponse(
            TaskResult {
              let (imageData, _) = try await URLSession.shared.data(from: url)
              
              guard let uiImage = UIImage(data: imageData) else {
                throw APIError.badRequest(400)
              }
              
              let image = Image(uiImage: uiImage)
              return image
            }
          )
        )
      }
      
    case ._fetchURLImageResponse(.success(let image)):
      state.loadingStatus = .success(image)
      return .none
      
    case ._fetchURLImageResponse(.failure):
      state.loadingStatus = .failure
      return .none
    }
  }
}

struct URLImage: View {
  var store: StoreOf<URLImageCore> {
    didSet {
      store.send(.onAppear)
    }
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        switch viewStore.loadingStatus {
        case .initial:
          EmptyView()
        case .inProgress:
          ProgressView()
            .progressViewStyle(.circular)
        case .success(let image):
          image
            .resizable()
        case .failure:
          Image("default_profile")
            .resizable()
        }
      }
      .scaledToFit()
      .frame(width: 65, height: 65)
      .clipShape(Circle())
      .onChange(of: viewStore.state) { _ in
        viewStore.send(.onAppear)
      }
    }
  }
}
