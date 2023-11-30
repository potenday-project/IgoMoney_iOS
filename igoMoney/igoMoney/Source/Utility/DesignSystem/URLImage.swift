//
//  URLImage.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import SwiftUI

import ComposableArchitecture

struct URLImageCore: Reducer {
  struct State: Equatable, Identifiable {
    var id: String {
      return urlPath ?? UUID().uuidString
    }
    
    var urlPath: String?
    var image: UIImage?
    var loadingStatus: LoadingState = .initial
  }
  
  enum LoadingState: Equatable {
    case initial
    case inProgress
    case success(_ image: Image)
    case failure
  }
  
  enum Action: Equatable {
    case fetchURLImage
    
    case _setURLPath(String?)
    case _fetchURLImageResponse(TaskResult<UIImage?>)
  }
  
  @Dependency(\.imageClient) var imageClient
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .fetchURLImage:
      if state.image != nil {
        return .none
      }
      
      guard let path = state.urlPath, let url = URL(string: path) else {
        return .send(._fetchURLImageResponse(.failure(APIError.badRequest(400))))
      }
      
      return .run { send in
        await send(
          ._fetchURLImageResponse(
            TaskResult {
              let imageData = try await imageClient.getImageData(url)
              let uiImage = UIImage(data: imageData)
              return uiImage
            }
          )
        )
      }
      
    case ._setURLPath(let path):
      if path == nil {
        return .send(._fetchURLImageResponse(.failure(APIError.badRequest(400))))
      }
      
      state.urlPath = path
      return .send(.fetchURLImage)
      
    case ._fetchURLImageResponse(.success(let image)):
      if let image = image {
        state.image = image
        state.loadingStatus = .success(Image(uiImage: image))
      }
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
    }
  }
}
