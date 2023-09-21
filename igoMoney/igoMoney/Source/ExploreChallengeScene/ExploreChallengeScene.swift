//
//  ExploreChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

enum MoneyType: CaseIterable, Hashable {
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
    var body: some View {
        VStack {
            HStack {
                Text("챌린지 리스트")
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .accentColor(.black)
            }
            .padding(.horizontal, 24)
            
            HStack(alignment: .center, spacing: 8) {
                ForEach(MoneyType.allCases, id: \.self) { money in
                    Button {

                    } label: {
                        Text(money.title)
                    }
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(8)
                    .font(.pretendard(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .background(ColorConstants.primary)
                    .cornerRadius(4)
                }
            }
            .padding(.horizontal, 24)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0..<100) { index in
                    HStack {
                        Image("default_profile")
                            .frame(width: 65, height: 65)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text("오마이머니님")
                                
                                Spacer()
                            }
                            .font(.pretendard(size: 12, weight: .medium))
                            
                            HStack {
                                Text("일주일에 3만원으로 살아남기")
                                
                                Spacer()
                            }
                            .font(.pretendard(size: 16, weight: .bold))
                            
                            HStack {
                                Text("30000원")
                                    .padding(.horizontal, 4)
                                    .background(Color.red)
                                    .cornerRadius(4)
                                
                                Text("내일부터 시작")
                                    .padding(.horizontal, 4)
                                    .background(Color.red)
                                    .cornerRadius(4)
                            }
                            .font(.pretendard(size: 12, weight: .medium))
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .shadow(
                        color: ColorConstants.gray2.opacity(0.2),
                        radius: 8,
                        y: 2
                    )
                }
            }
        }
    }
}

struct ExploreChallengeScene_Previews: PreviewProvider {
    static var previews: some View {
        ExploreChallengeScene()
    }
}
