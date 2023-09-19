//
//  igoMoneyApp.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

@main
struct igoMoneyApp: App {
    var body: some Scene {
        WindowGroup {
            AuthScene(
                store: Store(
                    initialState: AuthCore.State(),
                    reducer: { AuthCore() }
                )
            )
        }
    }
}
