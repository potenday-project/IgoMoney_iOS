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
        VStack {
            VStack(spacing: 12) {
                // Header Section
                headerSection
                
                // Filtering Section
                WithViewStore(store, observe: { $0 }) { viewStore in
                    ExploreChallengeFilterSection(viewStore: viewStore)
                }
            }
            
//            ScrollView(.vertical, showsIndicators: false) {
//                ForEach(0..<100) { index in
//
//                    .padding(.vertical, 12)
//                    .padding(.horizontal, 16)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .padding(.horizontal, 24)
//                    .padding(.vertical, 12)
//                    .shadow(
//                        color: ColorConstants.gray2.opacity(0.2),
//                        radius: 8,
//                        y: 2
//                    )
//                }
//            }
        }
        .background(Color.white)
    }
}

struct ExploreChallengeFilterSection: View {
    let viewStore: ViewStoreOf<ExploreChallengeCore>
    
    var body: some View {
        HStack {
            ForEach(MoneyType.allCases, id: \.self) { money in
                Button {
                    viewStore.send(.selectMoney(money))
                } label: {
                    Text(money.title)
                }
                .lineLimit(1)
                .padding(8)
                .font(.pretendard(size: 13, weight: .medium))
                .foregroundColor(
                    money == viewStore.selectedMoney ?
                        .black : ColorConstants.gray3
                )
                .background(
                    money == viewStore.selectedMoney ?
                    ColorConstants.primary : ColorConstants.gray5
                )
                .cornerRadius(4)
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
