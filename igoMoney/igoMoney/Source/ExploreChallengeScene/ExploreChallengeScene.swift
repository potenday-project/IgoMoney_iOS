//
//  ExploreChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

enum MoneyType: CaseIterable, Hashable, Equatable {
    case all
    case money(Int)
    
    var title: String {
        switch self {
        case .all:
            return "전체"
        case .money(let amount):
            return "\(amount)만원"
        }
    }
    
    static var allCases: [MoneyType] = [
        .all,
        .money(1),
        .money(2),
        .money(3),
        .money(4),
        .money(5)
    ]
}

struct ExploreChallengeScene: View {
    @Environment(\.presentationMode) var presentationMode
    let store: StoreOf<ExploreChallengeCore>
    
    @ViewBuilder
    var headerSection: some View {
        HStack {
            Text("챌린지 리스트")
                .font(.system(size: 20, weight: .bold))
            
            Spacer()
            
            Button {
                // TODO: - 챌린지 생성 이동 구현하기
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .accentColor(.black)
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: 12) {
                // Header Section
                headerSection
                
                // Filtering Section
                WithViewStore(store, observe: { $0 }) { viewStore in
                    ExploreChallengeFilterSection(viewStore: viewStore)
                        .padding(.horizontal, 24)
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEachStore(
                        store.scope(
                            state: \.challenges,
                            action: ExploreChallengeCore.Action.detailAction
                        )
                    ) { store in
                        ExploreChallengeDetail(store: store)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
        }
        .background(Color.white)
        .onAppear {
            store.send(._onAppear)
        }
        .navigationBarHidden(true)
    }
}

struct ExploreChallengeFilterSection: View {
    let viewStore: ViewStoreOf<ExploreChallengeCore>
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(MoneyType.allCases, id: \.self) { money in
                HStack(alignment: .center) {
                    Spacer()
                    
                    Text(money.title)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .font(.pretendard(size: 14, weight: .medium))
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .foregroundColor(
                    money == viewStore.selectedMoney ?
                        .black : ColorConstants.gray3
                )
                .background(
                    money == viewStore.selectedMoney ?
                    ColorConstants.primary : ColorConstants.gray5
                )
                .cornerRadius(4)
                .onTapGesture {
                    viewStore.send(.selectMoney(money))
                }
            }
        }
    }
}

struct ExploreChallengeScene_Previews: PreviewProvider {
    static var previews: some View {
        ExploreChallengeScene(
            store: Store(
                initialState: ExploreChallengeCore.State(),
                reducer: { ExploreChallengeCore() }
            )
        )
    }
}
