//
//  GenerateRoomScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct GenerateRoomScene: View {
  @State var showSelectStartDate: Bool = true
  let store: StoreOf<GenerateRoomCore>
  
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
      
      ScrollView(showsIndicators: false) {
        VStack(spacing: 24) {
          WithViewStore(store, observe: { $0 }) {
            GenerateRoomChallengeMoneyInputView(viewStore: $0)
            GenerateRoomChallengeCategoryInputSection(viewStore: $0)
            GenerateRoomChallengeStartDateInputSection(viewStore: $0)
            GenerateRoomChallengeTitleInputSection(viewStore: $0)
            GenerateRoomChallengeContentInputSection(viewStore: $0)
          }
        }
        .padding(.bottom)
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
      UIApplication.shared.hideKeyboard()
    }
  }
}

extension GenerateRoomScene {
  /// Target Money Selection Input Section
  struct GenerateRoomChallengeMoneyInputView: View {
    let viewStore: ViewStoreOf<GenerateRoomCore>
    
    @ViewBuilder
    func challengeTargetMoneyLabel(isSelection: Bool, moneyAmount: TargetMoneyAmount) -> some View {
      Text(moneyAmount.description)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(isSelection ? ColorConstants.primary7 : ColorConstants.gray5)
        .cornerRadius(4)
        .overlay(
          RoundedRectangle(cornerRadius: 4)
            .stroke(isSelection ? ColorConstants.primary : ColorConstants.gray5)
        )
        .font(
          isSelection ?
            .pretendard(size: 14, weight: .bold) : .pretendard(size: 14, weight: .medium)
        )
        .foregroundColor(isSelection ? ColorConstants.primary : ColorConstants.gray4)
    }
    
    var body: some View {
      IGOInputForm {
        Text("챌린지 금액")
          .font(.pretendard(size: 18, weight: .bold))
      } content: {
        HStack {
          ForEach(TargetMoneyAmount.allCases, id: \.money) { moneyAmount in
            Button {
              viewStore.send(.selectTargetAmount(moneyAmount))
            } label: {
              challengeTargetMoneyLabel(
                isSelection: moneyAmount == viewStore.targetAmount,
                moneyAmount: moneyAmount
              )
            }
            .buttonStyle(.plain)
          }
        }
      }
      .padding(.horizontal, 24)
    }
  }
  
  /// Challenge Category Selection Input Section
  struct GenerateRoomChallengeCategoryInputSection: View {
    let viewStore: ViewStoreOf<GenerateRoomCore>
    
    @ViewBuilder
    func challengeCategoryCell(
      isSelection: Bool,
      with category: ChallengeCategory
    ) -> some View {
      VStack(spacing: 8) {
        Text(category.emoji)
          .font(.pretendard(size: 28, weight: .bold))
        
        Text(category.description)
          .font(.pretendard(size: 14, weight: .bold))
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 12)
      .background(
        isSelection ? ColorConstants.primary7 : ColorConstants.gray5
      )
      .cornerRadius(4)
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .stroke(
            isSelection ? ColorConstants.primary : ColorConstants.gray5
          )
      )
    }
    
    var body: some View {
      IGOInputForm {
        Text("챌린지 주제")
          .font(.pretendard(size: 18, weight: .bold))
      } content: {
        LazyVGrid(columns: Array(repeating: .init(spacing: 8), count: 3), spacing: 8) {
          ForEach(ChallengeCategory.allCases, id: \.rawValue) { category in
            Button {
              viewStore.send(.selectCategory(category))
            } label: {
              challengeCategoryCell(
                isSelection: category == viewStore.selectionCategory,
                with: category
              )
            }
            .buttonStyle(.plain)
            .foregroundColor(
              category == viewStore.selectionCategory ?
              ColorConstants.primary : ColorConstants.gray4
            )
          }
        }
      }
      .padding(.horizontal, 24)
    }
  }
  
  /// Challenge StartDate Input Section
  struct GenerateRoomChallengeStartDateInputSection: View {
    let viewStore: ViewStoreOf<GenerateRoomCore>
    
    private func getAvailableDate() -> [Date] {
      var calendar = Calendar.current
      calendar.locale = Locale(identifier: "ko-KR")
      var dates: [Date] = []
      let currentDate = Date()
      
      guard let startDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
        return []
      }
      
      guard let endDate = calendar.date(byAdding: .day, value: 7, to: startDate) else {
        return []
      }
      
      var tempDate = startDate
      
      while tempDate <= endDate {
        dates.append(tempDate)
        guard let newDate = calendar.date(byAdding: .day, value: 1, to: tempDate) else {
          continue
        }
        
        tempDate = newDate
      }
      
      return dates
    }
    
    var body: some View {
      IGOInputForm {
        Text("챌린지 시작일")
          .font(.pretendard(size: 18, weight: .bold))
          .padding(.leading, 24)
      } content: {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(getAvailableDate(), id: \.description) { date in
              Button {
                
              } label: {
                Text(date.toString(with: "MM/d (EE)"))
                  .foregroundColor(ColorConstants.gray3)
              }
              .buttonStyle(.plain)
              .padding(.vertical, 8)
              .padding(.horizontal, 12)
              .background(ColorConstants.gray5)
              .cornerRadius(4)
            }
          }
          .padding(.horizontal, 24)
        }
      }
    }
  }
  
  /// Challenge Title Input Section
  struct GenerateRoomChallengeTitleInputSection: View {
    let viewStore: ViewStoreOf<GenerateRoomCore>
    
    var body: some View {
      IGOInputForm {
        Text("제목")
          .font(.pretendard(size: 18, weight: .bold))
      } subTitleView: {
        Text("최소 5자 / 최대 15자")
          .font(.pretendard(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray3)
      } content: {
        IGOTextField(
          text: viewStore.binding(
            get: \.title,
            send: GenerateRoomCore.Action.didChangeTitle
          ),
          placeholder: "제목을 입력하세요.",
          placeholderColor: ColorConstants.gray3
        )
        .font(.pretendard(size: 16, weight: .medium))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
          RoundedRectangle(cornerRadius: 4)
            .stroke(
              viewStore.isFillTitle ? ColorConstants.primary : ColorConstants.gray4,
              lineWidth: 1
            )
            .background(
              viewStore.isFillTitle ? ColorConstants.primary7 : .clear
            )
        )
      }
      .padding(.horizontal, 24)
    }
  }
  
  /// Challenge Content Input Section
  struct GenerateRoomChallengeContentInputSection: View {
    let viewStore: ViewStoreOf<GenerateRoomCore>
    
    var body: some View {
      IGOInputForm {
        Text("내용")
          .font(.pretendard(size: 18, weight: .bold))
      } subTitleView: {
        Text("최대 50자")
          .font(.pretendard(size: 12, weight: .medium))
          .foregroundColor(ColorConstants.gray3)
      } content: {
        TextEditor(
          text: viewStore.binding(
            get: \.content,
            send: GenerateRoomCore.Action.didChangeContent
          )
        )
        .font(.pretendard(size: 16, weight: .medium))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .textEditorBackground {
          RoundedRectangle(cornerRadius: 4)
            .stroke(
              viewStore.isFillContent ? ColorConstants.primary : ColorConstants.gray4,
              lineWidth: 2
            )
            .background(
              viewStore.isFillContent ? ColorConstants.primary7 : .clear
            )
            .cornerRadius(4)
        }
        .frame(height: 100)
      }
      .onAppear {
        UITextView.appearance().backgroundColor = .clear
      }
      .padding(.horizontal, 24)
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
