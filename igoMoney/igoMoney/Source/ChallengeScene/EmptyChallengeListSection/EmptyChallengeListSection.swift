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
        ChallengeSectionTitleView(sectionType: .emptyChallenge) {
            print("Move Empty List")
        }
        
        LazyVGrid(columns: generateGridItem(count: 2, spacing: 16), spacing: 12) {
            ForEach(1..<10, id: \.self) { _ in
                // TODO: - 각 뷰마다 Reducer 가질 수 있도록 변경
                VStack(alignment: .leading, spacing: 8) {
                    Text("같이 절약 챌린지 성공해봐요!")
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("아이고머니님")
                        .font(.system(size: 12, weight: .medium))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("50000원")
                            .padding(.horizontal, 2)
                            .background(ColorConstants.primary7)
                            .cornerRadius(4)
                        
                        Text("내일부터 시작")
                            .padding(.horizontal, 2)
                            .background(ColorConstants.primary7)
                            .cornerRadius(4)
                    }
                    .font(.system(size: 12, weight: .medium))
                    
                    HStack {
                        Spacer()
                        
                        Image("default_profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(
                            color: ColorConstants.gray2.opacity(0.3),
                            radius: 8,
                            y: 2
                        )
                )
            }
        }
    }
}

