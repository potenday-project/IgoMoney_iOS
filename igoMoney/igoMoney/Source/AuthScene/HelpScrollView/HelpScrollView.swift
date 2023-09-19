//
//  HelpScrollView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct HelpScrollView: View {
    let store: StoreOf<HelpScrollCore>
    
    var body: some View {
        VStack{
            GeometryReader { proxy in
                let width = proxy.size.width
                
                WithViewStore(store, observe: { $0 }) { viewStore in
                    TabView(
                        selection: Binding(
                            get: { viewStore.selectedHelp },
                            set: { viewStore.send(.selectItem($0)) }
                        )
                    ) {
                        ForEach(viewStore.informations, id: \.rawValue) { help in
                            HelpView(help: help)
                                .tag(help)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .scaledToFit()
                    
                    PageControl(
                        totalIndex: viewStore.informations.count,
                        selectedHelp: Binding(
                            get: { viewStore.selectedHelp },
                            set: { viewStore.send(.selectItem($0)) }
                        )
                    )
                    .frame(width: width, height: width * 2 + 50)
                }
            }
        }
        .frame(maxHeight: 400)
    }
}

struct PageControl: View {
    let totalIndex: Int
    @Binding var selectedHelp: HelpInformation
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(HelpInformation.allCases, id: \.rawValue) { help in
                if help == selectedHelp {
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
                        .frame(width: 10, height: 10)
                }
            }
        }
        .animation(.spring(), value: UUID())
    }
}


struct HelpView: View {
    let help: HelpInformation
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(help.title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(5)
            
            Text(help.body)
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(10)
            
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 150, height: 150)
        }
    }
}

struct HelpScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HelpScrollView(
            store: Store(
                initialState: HelpScrollCore.State(),
                reducer: { HelpScrollCore() }
            )
        )
    }
}
