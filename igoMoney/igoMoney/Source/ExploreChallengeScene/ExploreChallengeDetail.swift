//
//  ExploreChallengeDetail.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct ExploreChallengeDetail: View {
    let store: StoreOf<ChallengeDetailCore>
    
    var body: some View {
        HStack(alignment: .top) {
            WithViewStore(store, observe: { $0.user }) { viewStore in
                if let path = viewStore.profileImagePath {
                    Image(path)
                        .frame(width: 65, height: 65)
                } else {
                    Image("default_profile")
                        .frame(width: 65, height: 65)
                }
            }
            
            VStack(alignment: .leading, spacing: .zero) {
                WithViewStore(store, observe: { $0.user.nickName }) { viewStore in
                    Text(viewStore.state)
                        .font(.pretendard(size: 12, weight: .medium))
                }
                
                WithViewStore(store, observe: { $0.title }) { viewStore in
                    Text(viewStore.state)
                        .font(.pretendard(size: 16, weight: .bold))
                        .padding(.bottom, 2)
                }
                
                HStack {
                    WithViewStore(store, observe: { $0.targetMoneyDescription }) { viewStore in
                        Text(viewStore.state)
                            .padding(.horizontal, 4)
                            .background(Color.red)
                            .cornerRadius(4)
                    }
                    
                    Text("내일부터 시작")
                        .padding(.horizontal, 4)
                        .background(Color.red)
                        .cornerRadius(4)
                }
                .font(.pretendard(size: 12, weight: .medium))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct ExploreChallengeDetail_Previews: PreviewProvider {
    static var previews: some View {
        ExploreChallengeDetail(
            store: Store(
                initialState: ChallengeDetailCore.State(
                    id: UUID(),
                    title: "일주일에 3만원으로 살아남기",
                    content: "",
                    targetAmount: 10000,
                    user: User.default
                ), reducer: {
                    ChallengeDetailCore()
                }
            )
        )
        .previewLayout(.sizeThatFits)
        .background(Color.green)
        .padding()
    }
}
