//
//  GenerateRoomScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct GenerateRoomScene: View {
  let store: StoreOf<GenerateRoomCore>
  
  @ViewBuilder
  func challengeTargetMoneyLabel(
    to viewStore: ViewStore<GenerateRoomCore.State, GenerateRoomCore.Action>,
    moneyAmount: TargetMoneyAmount
  ) -> some View {
    Text(moneyAmount.description)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
      .background(
        moneyAmount == viewStore.targetAmount ?
        ColorConstants.primary7 : ColorConstants.gray5
      )
      .cornerRadius(4)
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .stroke(
            moneyAmount == viewStore.targetAmount ?
            ColorConstants.primary : ColorConstants.gray5
          )
      )
      .font(
        moneyAmount == viewStore.targetAmount ?
          .pretendard(size: 14, weight: .bold) : .pretendard(size: 14, weight: .medium)
      )
  }
  
  var body: some View {
    VStack(spacing: 24) {
      // 네비게이션 바
      IGONavigationBar {
        Text("챌린지 만들기")
          .font(.pretendard(size: 20, weight: .bold))
      } leftView: {
        Button {
          print("Tapped Dismiss")
        } label: {
          Image(systemName: "xmark")
            .resizable()
            .frame(width: 14, height: 14)
        }
      }
      .fixedSize(horizontal: false, vertical: true)
      .padding(.horizontal, 24)
      .padding(.top, 16)
      
      ScrollView {
        VStack(spacing: 24) {
          // 챌린지 금액 섹션
          IGOInputForm {
            Text("챌린지 금액")
              .font(.pretendard(size: 18, weight: .bold))
          } content: {
            HStack {
              WithViewStore(store, observe: { $0 }) { viewStore in
                ForEach(TargetMoneyAmount.allCases, id: \.money) { moneyAmount in
                  Button {
                    viewStore.send(.selectTargetAmount(moneyAmount))
                  } label: {
                    challengeTargetMoneyLabel(to: viewStore, moneyAmount: moneyAmount)
                  }
                  .buttonStyle(.plain)
                }
              }
            }
          }
          
          IGOInputForm {
            Text("챌린지 주제")
              .font(.pretendard(size: 18, weight: .bold))
          } content: {
            LazyVGrid(columns: Array(repeating: .init(), count: 3), spacing: 16) {
              ForEach(1...5, id: \.self) { index in
                VStack(spacing: 8) {
                  Text("💸")
                    .font(.pretendard(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity)
                  
                  Text("생활비")
                    .font(.pretendard(size: 14, weight: .bold))
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 12)
                .background(ColorConstants.primary7)
                .overlay(
                  RoundedRectangle(cornerRadius: 4)
                    .stroke(ColorConstants.primary, lineWidth: 1)
                )
              }
            }
          }
          
          // 챌린지 시작일 섹션
          IGOInputForm {
            Text("챌린지 시작일")
              .font(.pretendard(size: 18, weight: .bold))
          } content: {
            Button {
              
            } label: {
              HStack {
                Image(systemName: "calendar")
                
                Text("챌린지 시작일을 선택해주세요.")
                
                Spacer()
              }
              .font(.pretendard(size: 16, weight: .medium))
              .padding(.horizontal, 16)
              .padding(.vertical, 12)
            }
            .foregroundColor(ColorConstants.gray3)
            .buttonStyle(.plain)
            .background(
              RoundedRectangle(cornerRadius: 4)
                .stroke(ColorConstants.gray3)
            )
          }
          
          // 챌린지 제목 섹션
          IGOInputForm {
            Text("제목")
              .font(.pretendard(size: 18, weight: .bold))
          } subTitleView: {
            Text("최소 5자 / 최대 15자")
              .font(.pretendard(size: 12, weight: .medium))
              .foregroundColor(ColorConstants.gray3)
          } content: {
            TextView(
              configuration: .init(
                maxHeight: 200,
                textFont: .pretendard(size: 16, weight: .medium),
                textLimit: 15,
                cornerRadius: 4,
                borderWidth: 1,
                borderColor: UIColor(named: "gray4"),
                textContainerInset: .init(top: 12, left: 16, bottom: 12, right: 16),
                placeholder: "제목을 입력해주세요.",
                placeholderColor: UIColor(named: "gray3") ?? .gray
              ),
              text: .constant(""),
              height: .constant(.infinity)
            )
          }
          
          // 챌린지 내용 섹션
          IGOInputForm {
            Text("내용")
              .font(.pretendard(size: 18, weight: .bold))
          } subTitleView: {
            Text("최대 50자")
              .font(.pretendard(size: 12, weight: .medium))
              .foregroundColor(ColorConstants.gray3)
          } content: {
            TextView(
              configuration: .init(
                maxHeight: 200,
                textFont: .pretendard(size: 16, weight: .medium),
                textLimit: 50,
                cornerRadius: 4,
                borderWidth: 1,
                borderColor: UIColor(named: "gray4"),
                textContainerInset: .init(top: 12, left: 16, bottom: 12, right: 16),
                placeholder: "챌린지 내용을 입력해주세요.",
                placeholderColor: UIColor(named: "gray3") ?? .gray
              ),
              text: .constant(""),
              height: .constant(.infinity)
            )
            .frame(minHeight: 70, maxHeight: .infinity)
          }
        }
        .padding(.horizontal, 24)
      }
      
      Button {
        print("Tapped Complete Button")
      } label: {
        Text("완료")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.plain)
      .padding(16)
      .foregroundColor(ColorConstants.gray3)
      .background(ColorConstants.gray5)
      .cornerRadius(8)
      .padding(.horizontal, 24)
      .padding(.bottom, 8)
    }
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}

#Preview {
  GenerateRoomScene(
    store: Store(
      initialState: GenerateRoomCore.State(),
      reducer: { GenerateRoomCore() }
    )
  )
}
