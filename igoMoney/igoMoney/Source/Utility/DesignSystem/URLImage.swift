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
  
  @Dependency(\.imageClient) var imageClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      state.loadingStatus = .inProgress
      return .send(.fetchURLImage)
      
    case .fetchURLImage:
      guard let path = state.urlPath, let url = URL(string: path) else {
        return .send(._fetchURLImageResponse(.failure(APIError.badRequest(400))))
      }
      
      return .run { send in
        await send(
          ._fetchURLImageResponse(
            TaskResult {
              let imageData = try await imageClient.getImageData(url)
              guard let uiImage = UIImage(data: imageData) else {
                throw APIError.badRequest(400)
              }
              
              return Image(uiImage: uiImage)
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
  var store: StoreOf<URLImageCore>
  
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
      .onChange(of: viewStore.state) { _ in
        viewStore.send(.onAppear)
      }
    }
  }
}
