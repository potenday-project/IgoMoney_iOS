//
//  EmptyChallengeListSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct EmptyChallengeListSection: View {
    let store: StoreOf<EmptyChallengeListSectionCore>
    
    private func generateGridItem(count: Int, spacing: CGFloat) -> [GridItem] {
        let gridItem = GridItem(.flexible(), spacing: spacing)
        return Array(repeating: gridItem, count: count)
    }
    
    var body: some View {
        VStack {
            ChallengeSectionTitleView(sectionType: .emptyChallenge) {
                print("Move Empty List")
            }
            
            LazyVGrid(columns: generateGridItem(count: 2, spacing: 16), spacing: 12) {
                ForEachStore(store.scope(
                    state: \.challenges,
                    action: EmptyChallengeListSectionCore.Action.challengeDetail)
                ) { store in
                    EmptyChallengeDetail(store: store)
                }
            }
        }
        .onAppear {
            store.send(._onAppear)
        }
    }
}
