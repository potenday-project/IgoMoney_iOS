//
//  DeclarationScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

struct DeclarationReason: Hashable {
  let title: String
  
  static let defaultList: [DeclarationReason] = [
    DeclarationReason(title: "나체 이미지이거나 음란한 내용을 담고 있습니다."),
    DeclarationReason(title: "부적절한 상품을 팔거나 홍보하고 있습니다."),
    DeclarationReason(title: "자해나 자살과 관련된 내용 입니다."),
    DeclarationReason(title: "저작권, 명예훼손 등 기타 권리를 침해하는 내용입니다."),
    DeclarationReason(title: "특정인의 개인정보가 포함되어 있습니다."),
    DeclarationReason(title: "혐오를 조장하는 내용을 담고 있습니다.")
  ]
}

struct DeclarationCore: Reducer {
  struct State: Equatable {
    let record: ChallengeRecord
    var selectedReason: Int?
    var alertState = IGOAlertCore.State()
    var dismissView = false
  }
  
  enum Action: Equatable {
    case dismissView
    case didTapDeclaration(reason: Int)
    case acceptDeclaration
    
    case _postDeclaration
    case _postDeclarationResponse(TaskResult<Data>)
    
    case alertAction(IGOAlertCore.Action)
  }
  
  @Dependency(\.recordClient) var recordClient
  
  var body: some Reducer<State, Action> {
    Scope(state: \.alertState, action: /Action.alertAction) {
      IGOAlertCore()
    }
    
    Reduce { state, action in
      switch action {
      case .dismissView:
        state.dismissView = true
        return .none
        
      case let .didTapDeclaration(reason):
        state.selectedReason = reason
        return .send(.alertAction(.present))
        
      case .acceptDeclaration:
        
        return .send(._postDeclaration)
        
      case ._postDeclaration:
        guard let reason = state.selectedReason else {
          return .send(.alertAction(.dismiss))
        }
        
        return .run { [state = state] send in
          await send(
            ._postDeclarationResponse(
              TaskResult {
                try await recordClient.reportRecord(state.record, reason)
              }
            )
          )
        }
        
      case ._postDeclarationResponse(.success):
        return .concatenate(
          .send(.dismissView),
          .send(.alertAction(.dismiss))
        )
        
      case ._postDeclarationResponse(.failure):
        return .send(.alertAction(.dismiss))
        
      case .alertAction:
        return .none
      }
    }
  }
}

struct DeclarationScene: View {
  @Environment(\.presentationMode) var presentationMode
  let store: StoreOf<DeclarationCore>
  
  var body: some View {
    NavigationView {
      VStack(spacing: .zero) {
        IGONavigationBar {
          Text("신고하기")
            .font(.pretendard(size: 20, weight: .bold))
        } leftView: {
          Button {
            // TODO: - 신고 화면 취소
          } label: {
            Image("icon_xmark")
          }
        } rightView: {
          EmptyView()
        }
        .padding(.vertical, 24)
        
        ScrollView(.vertical, showsIndicators: false) {
          ForEach(
            0..<DeclarationReason.defaultList.count,
            id: \.self
          ) { index in
            let reason = DeclarationReason.defaultList[index]
            Button {
              store.send(.didTapDeclaration(reason: index))
            } label: {
              HStack {
                Text(reason.title)
                  .font(.pretendard(size: 16, weight: .semiBold))
                  .lineHeight(font: .pretendard(size: 16, weight: .semiBold), lineHeight: 21)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                  .foregroundColor(ColorConstants.gray4)
              }
              .padding(16)
            }
            .buttonStyle(.plain)
            
            Divider()
          }
        }
      }
      .padding(.horizontal, 24)
      .navigationBarHidden(true)
      .igoAlert(
        store.scope(
          state: \.alertState,
          action: DeclarationCore.Action.alertAction
        )
      ) {
        DeclarationAlertView(store: self.store)
      }
      .onChange(
        of: ViewStore(store, observe: { $0.dismissView }).state
      ) { newValue in
        if newValue {
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

struct DeclarationAlertView: View {
  let store: StoreOf<DeclarationCore>
  
  var body: some View {
    VStack(spacing: 16) {
      Text("신고 내용은 아이고머니 이용약관 및 정책에 의해서 처리되며, 허위신고 시 서비스 이용이 재한될 수 있습니다.")
        .font(.pretendard(size: 16, weight: .medium))
        .multilineTextAlignment(.center)
      
      HStack {
        Button {
          store.send(.alertAction(.dismiss))
        } label: {
          Text("취소")
            .frame(maxWidth: .infinity)
            .font(.pretendard(size: 16, weight: .medium))
            .foregroundColor(ColorConstants.gray3)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(ColorConstants.gray5)
        .cornerRadius(8)
        
        Button {
          store.send(.acceptDeclaration)
        } label: {
          Text("신고하기")
            .frame(maxWidth: .infinity)
            .font(.pretendard(size: 16, weight: .medium))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(ColorConstants.primary)
        .cornerRadius(8)
      }
      .foregroundColor(.black)
    }
    .frame(maxWidth: 200)
    .padding(24)
    .background(Color.white)
    .cornerRadius(8)
  }
}

#Preview {
  DeclarationScene(
    store: Store.init(
      initialState: DeclarationCore.State(record: .default),
      reducer: { DeclarationCore() }
    )
  )
}

#Preview("Alert") {
  DeclarationAlertView(
    store: Store.init(
      initialState: DeclarationCore.State(record: .default),
      reducer: { DeclarationCore() }
    )
  )
}
