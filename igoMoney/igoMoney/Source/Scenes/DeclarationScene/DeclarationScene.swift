//
//  DeclarationScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI
import ComposableArchitecture

enum Declaration: CaseIterable {
  case spam
  case inapposite
  
  var description: String {
    switch self {
    case .spam:
      return "스팸 내용입니다."
    case .inapposite:
      return "부적절한 내용입니다."
    }
  }
  
  func allReason() -> [String] {
    if self == .inapposite {
      return [
        "나체 이미지이거나 음란한 내용을 담고 있습니다.",
        "부적절한 상품을 팔거나 홍보하고 있습니다.",
        "자해나 자살과 관련된 내용 입니다.",
        "저작권, 명예훼손 등 기타 권리를 침해하는 내용입니다.",
        "특정인의 개인정보가 포함되어 있습니다.",
        "혐오를 조장하는 내용을 담고 있습니다."
      ]
    }
    
    return []
  }
}

struct DeclarationCore: Reducer {
  struct State: Equatable {
    let record: ChallengeRecord
    var showReasonView: Bool = false
  }
  
  enum Action: Equatable {
    case didTapDeclaration
    case didTapShowReason(isShow: Bool)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .didTapShowReason(true):
      state.showReasonView = true
      return .none
      
    case .didTapShowReason(false):
      state.showReasonView = false
      return .none
      
    default:
      return .none
    }
  }
}

struct DeclarationScene: View {
  let store: StoreOf<DeclarationCore>
  
  var body: some View {
    NavigationView {
      ZStack {
        WithViewStore(store, observe: { $0 }) { viewStore in
          NavigationLink(
            destination: Text("Reason View"),
            isActive: viewStore.binding(
              get: \.showReasonView,
              send: DeclarationCore.Action.didTapDeclaration
            )
          ) {
            EmptyView()
          }
        }
        
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
            ForEach(Declaration.allCases, id: \.hashValue) { declaration in
              Button {
                if declaration == .inapposite {
                  store.send(.didTapShowReason(isShow: true))
                  return
                }
                store.send(.didTapDeclaration)
              } label: {
                HStack {
                  Text(declaration.description)
                  
                  Spacer()
                  
                  Image(systemName: "chevron.right")
                    .foregroundColor(ColorConstants.gray4)
                }
                .font(.pretendard(size: 16, weight: .semiBold))
                .padding(16)
              }
              .buttonStyle(.plain)
              
              Divider()
            }
          }
          
        }
        .padding(.horizontal, 24)
      }
      .navigationBarHidden(true)
    }
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
