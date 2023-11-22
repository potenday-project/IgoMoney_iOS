//
//  IGOAlertCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import ComposableArchitecture

struct IGOAlertCore: Reducer {
  struct State: Equatable {
    var alertStartPosition: CGSize
    var alertPresentedPosition: CGSize
    var alertEndPosition: CGSize
    var endScripOpacity: CGFloat
    var isPresented: Bool
    
    internal var modalOffset: CGSize
    internal var modalOpacity: CGFloat
    internal var scrimOpacity: CGFloat
    internal var contentAllowsHitTesting: Bool = true
    
    init(
      alertStartPosition: CGSize = .init(width: .zero, height: 500),
      alertPresentedPosition: CGSize = .zero,
      alertEndPosition: CGSize = .init(width: .zero, height: -500),
      endScripOpacity: CGFloat = 0.6
    ) {
      self.alertStartPosition = alertStartPosition
      self.alertPresentedPosition = alertPresentedPosition
      self.alertEndPosition = alertEndPosition
      self.endScripOpacity = endScripOpacity
      
      self.isPresented = false
      
      self.modalOffset = alertStartPosition
      self.modalOpacity = .zero
      self.scrimOpacity = .zero
    }
  }
  
  enum Action: Equatable {
    case present
    case dismiss
    case scrimTapped
    case scrimOpacityChanged(opacity: CGFloat)
    case modalOffsetChanged(offset: CGSize)
    case modalOpacityChanged(opacity: CGFloat)
  }
  
  init() { }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .present:
      state.isPresented = true
      state.contentAllowsHitTesting = false
      return .concatenate(
        .run { [position = state.alertPresentedPosition] send in
          await send(.modalOffsetChanged(offset: position), animation: .spring)
        },
        .run { send in
          await send(.modalOpacityChanged(opacity: 1), animation: .default)
        },
        .run { send in
          await send(.scrimOpacityChanged(opacity: 1), animation: .default)
        }
      )
    case .dismiss:
      state.isPresented = false
      state.contentAllowsHitTesting = true
      return .concatenate(
        .run { [position = state.alertEndPosition] send in
          await send(.modalOffsetChanged(offset: position), animation: .easeInOut)
        },
        .run { send in
          await send(.modalOpacityChanged(opacity: .zero), animation: .default)
        },
        .run { send in
          await send(.scrimOpacityChanged(opacity: .zero), animation: .default)
        },
        .run { [start = state.alertStartPosition] send in
          try await Task.sleep(nanoseconds: 5_000_000)
          await send(.modalOffsetChanged(offset: start))
        }
      )
    case .scrimTapped:
      return .send(.dismiss)
      
    case .scrimOpacityChanged(let opacity):
      state.scrimOpacity = opacity
      return .none
      
    case .modalOffsetChanged(let offset):
      state.modalOffset = offset
      return .none
      
    case .modalOpacityChanged(let opacity):
      state.modalOpacity = opacity
      return .none
    }
  }
}

extension IGOAlertCore.State {
  init(
    alertStartPosition: CGSize = .init(width: 0, height: 500),
    alertPresentedPosition: CGSize = .zero,
    alertEndPosition: CGSize = .init(width: 0, height: -500),
    endScrimOpacity: CGFloat = 0.6,
    isPresented: Bool = false,
    modalOffset: CGSize = .zero,
    modalOpacity: CGFloat = .zero,
    scrimOpacity: CGFloat = .zero,
    contentAllowsHitTesting: Bool = true
  ) {
    self.alertStartPosition = alertStartPosition
    self.alertPresentedPosition = alertPresentedPosition
    self.alertEndPosition = alertEndPosition
    self.endScripOpacity = endScrimOpacity
    self.isPresented = isPresented
    self.modalOffset = modalOffset
    self.modalOpacity = modalOpacity
    self.scrimOpacity = scrimOpacity
    self.contentAllowsHitTesting = contentAllowsHitTesting
  }
}
