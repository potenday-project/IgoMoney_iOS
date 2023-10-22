//
//  UserProfileSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct UserProfileSection: View {
  let store: StoreOf<UserProfileCore>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack(spacing: 8) {
        
        URLImage(
          store: store.scope(
            state: \.profileImageState,
            action: UserProfileCore.Action.profileImageAction
          )
        )
        
        VStack(alignment: .leading) {
          Text(viewStore.userName)
            .foregroundColor(ColorConstants.primary)
          + Text("님")
          
          Text(
            viewStore.myChallengeState.userChallenge == .notInChallenge ?
            "챌린지에 참여해보세요!" : "현재 챌린지 진행 중!"
          )
        }
        .font(.pretendard(size: 18, weight: .semiBold))
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .foregroundColor(ColorConstants.gray4)
      }
    }
    .padding(16)
    .background(Color.white)
    .cornerRadius(8)
    .shadow(
      color: ColorConstants.gray3.opacity(0.2),
      radius: 4,
      y: 2
    )
    .onAppear {
      store.send(.onAppear)
    }
  }
}

#Preview {
  UserProfileSection(
    store: Store(
      initialState: UserProfileCore.State(),
      reducer: { UserProfileCore() }
    )
  )
  .previewLayout(.sizeThatFits)
  .padding()
  .background(Color.red)
}
