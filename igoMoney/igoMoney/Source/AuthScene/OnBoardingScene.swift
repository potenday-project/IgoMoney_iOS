//
//  OnBoardingScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct OnBoardingInformation {
    let id = UUID()
    
    let title: String
    let body: String
    let imageName: String
    
    static let defaultValues: [Self] = [
        .init(title: "일주일간 무지출 챌린지\n도전해보세요!", body: "다른 유저와 함께 일주일간\n무지출 챌린지에 도전하세요.", imageName: "person.circle"),
        .init(title: "일주일간 무지출 챌린지\n도전해보세요!", body: "다른 유저와 함께 일주일간\n무지출 챌린지에 도전하세요.", imageName: "person.circle"),
        .init(title: "일주일간 무지출 챌린지\n도전해보세요!", body: "다른 유저와 함께 일주일간\n무지출 챌린지에 도전하세요.", imageName: "person.circle"),
    ]
}

struct OnBoardingScene: View {
    
    var body: some View {
        VStack {
            ImageScrollBannerView()
                .padding(.top, 50)
            
            AuthButton(
                title: "카카오로 로그인",
                iconName: "icon_kakao",
                color: Color("kakao_color")
            ) {
                print("카카오")
            }
            .padding(.horizontal, 24)
            
            AuthButton(
                title: "애플로 로그인",
                iconName: "icon_apple",
                color: .white
            ) {
                print("애플")
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke()
            )
            .padding(.horizontal, 24)
        }
    }
}

struct ImageScrollBannerView: View {
    private let informations = OnBoardingInformation.defaultValues
    @State var selectedIndex: Int = .zero
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            
            TabView(selection: $selectedIndex) {
                ForEach(0..<informations.count, id: \.self) { index in
                    let information = informations[index]
                    
                    OnBoardingView(onBoardingInformation: information)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: width, height: width, alignment: .center)
            
            PageControl(
                totalIndex: informations.count,
                selectedIndex: $selectedIndex
            )
            .frame(width: width, height: width * 2 + 30)
        }
    }
}

struct PageControl: View {
    let totalIndex: Int
    @Binding var selectedIndex: Int
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<totalIndex, id: \.self) { index in
                if index == selectedIndex {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 13, height: 13)
                        .matchedGeometryEffect(
                            id: "IndicatorAnimationID",
                            in: animation
                        )
                } else {
                    Circle()
                        .fill(.gray)
                        .frame(width: 13, height: 13)
                }
            }
        }
        .animation(.spring(), value: UUID())
    }
}


struct OnBoardingView: View {
    let onBoardingInformation: OnBoardingInformation
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(onBoardingInformation.title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(5)
            
            Text(onBoardingInformation.body)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(10)
            
            Image(systemName: onBoardingInformation.imageName)
                .resizable()
                .frame(width: 150, height: 150)
        }
    }
}

struct OnBoarding_Preview: PreviewProvider {
    static var previews: some View {
        OnBoardingScene()
    }
}
