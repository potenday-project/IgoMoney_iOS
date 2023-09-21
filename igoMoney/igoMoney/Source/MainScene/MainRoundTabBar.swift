//
//  MainRoundTabBar.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

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
    @Binding var selectedTab: MainTab
    let tabSetting: TabConfiguration
    let shadowSetting: ShadowConfiguration
    var content: () -> Content
    
    init(
        selectedTab: Binding<MainTab>,
        tabSetting: TabConfiguration = .default,
        shadowSetting: ShadowConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selectedTab = selectedTab
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
                
                ForEach(MainTab.allCases, id: \.title) { tab in
                    TabItem(
                        tab: tab,
                        tabSetting: tabSetting,
                        isActive: selectedTab == tab
                    )
                    .onTapGesture {
                        selectedTab = tab
                    }
                    
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

extension RoundTabBar {
    func TabItem(
        tab: MainTab,
        tabSetting: TabConfiguration,
        isActive: Bool
    ) -> some View {
        VStack {
            Image(isActive ? tab.selectedIconName : tab.unSelectedIconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .foregroundColor(
                    isActive ? tabSetting.accentColor : tabSetting.defaultColor
                )
            
            Text(tab.title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(
                    isActive ? tabSetting.accentColor : tabSetting.defaultColor
                )
        }
        .animation(.easeIn, value: UUID())
    }
}
