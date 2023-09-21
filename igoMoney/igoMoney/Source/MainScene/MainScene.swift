//
//  ContentView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MainCore: Reducer {
    struct State {
        enum Tab {
            case challenge
            case myPage
            
            var selectedIconName: String {
                switch self {
                case .challenge:
                    return "icon_bolt_selected"
                case .myPage:
                    return "icon_person_selected"
                }
            }
            
            var unSelectedIconName: String {
                switch self {
                case .challenge:
                    return "icon_bolt_unselected"
                case .myPage:
                    return "icon_person_unselected"
                }
            }
            
            var title: String {
                switch self {
                case .challenge:
                    return "챌린지"
                case .myPage:
                    return "마이페이지"
                }
            }
        }
        
        var selectedTab: Tab = .challenge
    }
    
    enum Action {
        case selectedTabChange(State.Tab)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}

struct MainScene: View {
    @State private var selectedIndex = 1
    var body: some View {
        RoundTabBar(
            tabSetting: .default,
            shadowSetting: ShadowConfiguration(
                color: ColorConstants.gray6,
                radius: 10,
                x: .zero,
                y: 5
            )
        ) {
            ZStack {
                switch selectedIndex {
                case 1:
                    Text("First")
                default:
                    EmptyView()
                }
            }
            .background(Color.red)
        }
    }
}

public struct ShadowConfiguration {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    static let `default` = ShadowConfiguration(
        color: .clear,
        radius: .zero,
        x: .zero,
        y: .zero
    )
}

public struct TabConfiguration {
    let accentColor: Color
    let defaultColor: Color
    let cornerRadius: Int
    
    static let `default` = TabConfiguration(
        accentColor: ColorConstants.primary,
        defaultColor: ColorConstants.gray6,
        cornerRadius: 10
    )
}

struct RoundTabBar<Content: View>: View {
    let tabSetting: TabConfiguration
    let shadowSetting: ShadowConfiguration
    var content: () -> Content
    
    init(
        tabSetting: TabConfiguration = .default,
        shadowSetting: ShadowConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.tabSetting = tabSetting
        self.shadowSetting = shadowSetting
        self.content = content
    }
    
    var body: some View {
        VStack {
            content()
            
            Spacer()
            
            HStack {
                Spacer()
                
                ForEach(1..<3, id: \.self) { index in
                    VStack {
                        Image("icon_bolt_unselected")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(tabSetting.defaultColor)
                        
                        Text("챌린지")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(tabSetting.defaultColor)
                    }
                    .animation(.easeIn, value: UUID())
                    
                    Spacer()
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 24)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(
                color: shadowSetting.color,
                radius: shadowSetting.radius,
                y: shadowSetting.y
            )
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScene()
    }
}
