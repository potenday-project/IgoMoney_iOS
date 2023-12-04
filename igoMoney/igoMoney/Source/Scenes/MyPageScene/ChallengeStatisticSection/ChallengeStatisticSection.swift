//
//  ChallengeStatisticSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ChallengeStatisticSection: View {
  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 8) {
        ForEach(ChallengeCounterType.allCases, id: \.rawValue) { counter in
          ChallengeCounterView(
            store: Store(
              initialState: ChallengeCounterCore.State(challengeType: counter),
              reducer: { ChallengeCounterCore() }
            )
          )
        }
      }
    }
  }
}

enum ChallengeCounterType: Int, CaseIterable {
  case win
  case total
  
  var title: String {
    switch self {
    case .win:
      return "승리"
    case .total:
      return "누적"
    }
  }
}

#Preview {
  ChallengeStatisticSection()
    .padding()
}
