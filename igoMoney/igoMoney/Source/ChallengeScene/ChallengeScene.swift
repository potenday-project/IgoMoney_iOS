//
//  ChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ChallengeScene: View {
    @ViewBuilder
    var titleHeader: some View {
        HStack {
            Image("icon_text_main")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            
            Spacer()
        }
        .padding(24)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                titleHeader
                
                VStack {
                    VStack(spacing: 16) {
                        MyChallengeSection()
                        EmptyChallengeSection()
                    }
                    .padding([.horizontal, .top], 24)
                    .padding(.bottom, 28)
                }
                .background(Color.white)
                .cornerRadius(20, corner: .topLeft)
                .cornerRadius(20, corner: .topRight)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .background(
            Color("background_color")
                .edgesIgnoringSafeArea(.top)
        )
        .onAppear {
            UIScrollView.appearance().bounces = false
        }
        .onDisappear {
            UIScrollView.appearance().bounces = true
        }
    }
}

extension ChallengeScene {
    enum Section {
        case myChallenge
        case emptyChallenge
        
        var title: String {
            switch self {
            case .myChallenge:
                return "🔥 참여중인 챌린지"
            case .emptyChallenge:
                return "📣 대기중인 챌린지"
            }
        }
        
        var detail: String? {
            switch self {
            case .myChallenge:
                return nil
            case .emptyChallenge:
                return "내가 도전하고 싶은 챌린지를 선택하세요."
            }
        }
        
        var hasButton: Bool {
            return self == .emptyChallenge
        }
    }
}

struct MyChallengeSection: View {
    // TODO: - 섹션 reducer 연결하기
    var body: some View {
        ChallengeSectionTitleView(
            sectionType: .myChallenge,
            buttonAction: nil
        )
        
        // TODO: - 상태에 따른 화면 구현
        RoundedRectangle(cornerRadius: 8)
            .frame(height: 100)
    }
}

struct EmptyChallengeSection: View {
    private let gridItems: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        ChallengeSectionTitleView(sectionType: .emptyChallenge) {
            print("Move Empty List")
        }
        
        LazyVGrid(columns: gridItems, spacing: 12) {
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

struct ChallengeSectionTitleView: View {
    let sectionType: ChallengeScene.Section
    let buttonAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(sectionType.title)
                    .font(.system(size: 30, weight: .bold))
                
                Spacer()
                
                if sectionType.hasButton {
                    // TODO: - Button 생성
                    Button {
                        buttonAction?()
                    } label: {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }

                }
            }
            
            if let detail = sectionType.detail {
                Text(detail)
                    .font(.system(size: 14, weight: .medium))
            }
        }
    }
}

struct ChallengeScene_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeScene()
    }
}
