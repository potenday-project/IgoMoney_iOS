//
//  EnterChallengeButton.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct EnterChallengeButton: View {
  let store: StoreOf<EnterChallengeButtonCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        viewStore.send(.didTapButton)
      } label: {
        Text("챌린지 참가하기")
      }
      .padding()
      .frame(maxWidth: .infinity)
      .font(.pretendard(size: 18, weight: .medium))
      .foregroundColor(
        viewStore.canEnter ? .black : ColorConstants.gray3
      )
      .background(
        viewStore.canEnter ? ColorConstants.primary : ColorConstants.gray5
      )
      .cornerRadius(8)
      .disabled(viewStore.canEnter == false)
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  EnterChallengeButton(
    store: Store(
      initialState: EnterChallengeButtonCore.State(),
      reducer: { EnterChallengeButtonCore() }
    )
  )
}
