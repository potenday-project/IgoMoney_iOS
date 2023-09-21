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
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            WithViewStore(store, observe: { $0 }) { viewStore in
                if viewStore.selectedTab == .challenge {
                    ChallengeScene(
                        store: store.scope(
                            state: \.challengeState,
                            action: MainCore.Action.challengeAction
                        )
                    )
                    .padding(.bottom, 60)
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ForEach(MainTab.allCases, id: \.title) { tab in
                            VStack {
                                Image(
                                    viewStore.selectedTab == tab ?
                                    tab.selectedIconName : tab.unSelectedIconName
                                )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(
                                    viewStore.selectedTab == tab ?
                                    ColorConstants.primary : ColorConstants.gray3
                                )
                                
                                Text(tab.title)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(
                                        viewStore.selectedTab == tab ?
                                        ColorConstants.primary : ColorConstants.gray3
                                    )
                            }
                            .onTapGesture {
                                viewStore.send(.selectedTabChange(tab))
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(
                        color: ColorConstants.gray3,
                        radius: 10,
                        y: 5
                    )
                }
                .edgesIgnoringSafeArea(.bottom)
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
