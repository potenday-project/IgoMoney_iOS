//
//  ContentView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct MainScene: View {
    let store: StoreOf<MainCore>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            RoundTabBar(
                selectedTab: viewStore.binding(
                    get: \.selectedTab,
                    send: MainCore.Action.selectedTabChange
                ),
                tabSetting: .default,
                shadowSetting: ShadowConfiguration(
                    color: ColorConstants.gray6,
                    radius: 10,
                    x: .zero,
                    y: 5
                )
            ) {
                ScrollView {
                    ForEach(1..<100) { index in
                        HStack {
                            Text(index.description)
                            
                            Spacer()
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScene(
            store: Store(
                initialState: MainCore.State(),
                reducer: { MainCore() }
            )
        )
    }
}
