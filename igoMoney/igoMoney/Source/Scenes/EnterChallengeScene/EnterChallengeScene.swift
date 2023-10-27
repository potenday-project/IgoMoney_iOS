//
//  EnterChallengeScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct EnterChallengeScene: View {
  @Environment(\.presentationMode) var presentationMode
  let store: StoreOf<EnterChallengeCore>
  
  @ViewBuilder
  private var navigationSection: some View {
    IGONavigationBar {
      Text("챌린지 참여하기")
        .font(.pretendard(size: 20, weight: .bold))
    } leftView: {
      Button {
        store.send(.dismissView)
      } label: {
        Image(systemName: "chevron.left")
          .font(.pretendard(size: 22, weight: .bold))
      }
    } rightView: {
      EmptyView()
    }
    .padding(.top, 16)
    .foregroundColor(.white)
    .padding(.horizontal, 24)
  }
  
  var body: some View {
    ZStack {
      VStack {
        navigationSection // Navigation Section
        
        ChallengeInformationCardView(
          store: self.store.scope(
            state: \.challengeInformationState,
            action: EnterChallengeCore.Action.enterChallengeInformationAction
          )
        )
        
        VStack(spacing: 16) {
          VStack {
            ChallengeNoticeView()
            
            Spacer()
            
            EnterChallengeButton(
              store: self.store.scope(
                state: \.enterChallengeButtonState,
                action: EnterChallengeCore.Action.enterChallengeButtonAction
              )
            )
          }
          .padding(24)
          .background(Color.white)
          .cornerRadius(20, corner: .topLeft)
          .cornerRadius(20, corner: .topRight)
        } // Main Section
        .edgesIgnoringSafeArea(.bottom)
      }
      .background(
        Color("background_color")
          .edgesIgnoringSafeArea(.top)
      )
      .navigationBarHidden(true)
      .onChange(of: ViewStore(store, observe: { $0.dismissView }).state, perform: { newValue in
        if newValue {
          presentationMode.wrappedValue.dismiss()
        }
      })
      .igoAlert(
        store.scope(
          state: \.alertState,
          action: EnterChallengeCore.Action.alertAction
        )
      ) {
        ChallengeEnterAlertView(store: store)
      }
    }
  }
}

extension EnterChallengeScene {
  /// Challenge Enter Confirm Alert View
  struct ChallengeEnterAlertView: View {
    let store: StoreOf<EnterChallengeCore>
    
    var body: some View {
      WithViewStore(store, observe: { $0 }) { viewStore in
        VStack(spacing: 24) {
          Text(viewStore.alertTitle)
            .font(.pretendard(size: 15, weight: .medium))
            .lineHeight(font: .pretendard(size: 15, weight: .medium), lineHeight: 22)
          
          HStack {
            Button {
              viewStore.send(.alertAction(.dismiss))
            } label: {
              Text("아니요")
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(ColorConstants.gray5)
            .foregroundColor(ColorConstants.gray3)
            .cornerRadius(8)
            
            Button {
              viewStore.send(.alertAction(.dismiss))
            } label: {
              Text("네")
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(ColorConstants.primary)
            .cornerRadius(8)
          }
          .font(.pretendard(size: 16, weight: .medium))
          .lineHeight(font: .pretendard(size: 16, weight: .medium), lineHeight: 22)
        }
        .foregroundColor(Color.black)
        .padding(24)
        .background(Color.white)
        .cornerRadius(8)
        .frame(maxWidth: 250)
      }
    }
  }
}

#Preview {
  EnterChallengeScene(
    store: Store(
      initialState: EnterChallengeCore.State(challenge: .default),
      reducer: { EnterChallengeCore() }
    )
  )
}

#Preview("Alert View") {
  EnterChallengeScene.ChallengeEnterAlertView(
    store: Store(
      initialState: EnterChallengeCore.State(challenge: .default),
      reducer: { EnterChallengeCore() }
    )
  )
  .padding()
  .background(ColorConstants.gray4)
}
