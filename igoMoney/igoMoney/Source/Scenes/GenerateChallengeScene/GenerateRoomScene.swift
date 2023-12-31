//
//  GenerateRoomScene.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct GenerateRoomScene: View {
  @Environment(\.presentationMode) var presentationMode
  let store: StoreOf<GenerateRoomCore>
  
  var body: some View {
    ZStack {
      VStack(spacing: 24) {
        // Navigation Bar
        IGONavigationBar {
          Text("챌린지 만들기")
            .font(.pretendard(size: 20, weight: .bold))
        } leftView: {
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image(systemName: "xmark")
              .resizable()
              .frame(width: 14, height: 14)
          }
          .foregroundColor(.black)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 24)
        .padding(.top, 16)
        
        // Challenge Information Input Form
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
        
        // Challenge Generate Button
        WithViewStore(store, observe: { $0 }) { viewStore in
          Button {
            UIApplication.shared.hideKeyboard()
            viewStore.send(.didEnterChallenge)
          } label: {
            Text("완료")
              .font(.pretendard(size: 18, weight: .medium))
          }
          .frame(maxWidth: .infinity)
          .disabled(viewStore.isSendable == false)
          .buttonStyle(.plain)
          .padding(16)
          .foregroundColor(
            viewStore.isSendable ? Color.black : ColorConstants.gray3
          )
          .background(
            viewStore.isSendable ? ColorConstants.primary : ColorConstants.gray5
          )
          .cornerRadius(8)
          .padding(.horizontal, 24)
          .padding(.bottom, 8)
        }
      }
    }
    .onTapGesture {
      UIApplication.shared.hideKeyboard()
    }
    .igoAlert(
      self.store.scope(
        state: \.alertState,
        action: GenerateRoomCore.Action.alertAction
      )
    ) {
      ChallengeGenerateResultAlertView(store: self.store)
    }
  }
}

extension GenerateRoomScene {
  /// Target Money Selection Input Section
  struct GenerateRoomChallengeMoneyInputView: View {
    let viewStore: ViewStoreOf<GenerateRoomCore>
    
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
              ChallengeTargetMoneyView(
                isSelection: moneyAmount == viewStore.targetAmount,
                amount: moneyAmount
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
              ChallengeCategoryView(
                isSelection: category == viewStore.selectionCategory,
                category: category
              )
            }
            .buttonStyle(.plain)
          }
        }
      }
      .padding(.horizontal, 24)
    }
  }
  
  /// Challenge StartDate Input Section
  struct GenerateRoomChallengeStartDateInputSection: View {
    let viewStore: ViewStoreOf<GenerateRoomCore>
    let allDates = getAvailableDate()
    
    static func getAvailableDate() -> [Date] {
      var calendar = Calendar.current
      calendar.locale = Locale(identifier: "ko-KR")
      var dates: [Date] = []
      let currentDate = Date()
      
      var temp = currentDate
      
      (calendar.shortWeekdaySymbols).forEach { m in
        guard let newDate = calendar.date(byAdding: .day, value: 1, to: temp) else {
          return
        }
        
        let components = calendar.dateComponents([.year, .month, .day], from: newDate)
        guard let date = calendar.date(from: components) else {
          return
        }
        
        temp = date
        dates.append(temp)
      }
      
      return dates
    }
    
    @ViewBuilder
    func ChallengeStartDateCell(isSelected: Bool, date: Date) -> some View {
      Text(date.toString(with: "MM/d (EE)"))
        .foregroundColor(isSelected ? ColorConstants.primary : ColorConstants.gray3)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
          ZStack {
            isSelected ? ColorConstants.primary7 : ColorConstants.gray5
            RoundedRectangle(cornerRadius: 4)
              .stroke(isSelected ? ColorConstants.primary : ColorConstants.gray5)
          }
        )
        .cornerRadius(4)
    }
    
    var body: some View {
      IGOInputForm {
        Text("챌린지 시작일")
          .font(.pretendard(size: 18, weight: .bold))
          .padding(.leading, 24)
      } content: {
        VStack(spacing: 12) {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              ForEach(allDates, id: \.description) { date in
                Button {
                  viewStore.send(.selectDate(date))
                } label: {
                  ChallengeStartDateCell(
                    isSelected: date == viewStore.startDate,
                    date: date
                  )
                }
                .buttonStyle(.plain)
              }
            }
            .padding(.horizontal, 24)
          }
          
          if let startDate = viewStore.startDate {
            HStack {
              Image(systemName: "calendar")
              
              Text(
                "\(startDate.toString(with: "MM/d (EE)")) ~ \(viewStore.endDate.toString(with: "MM/d (EE)"))"
              )
              
              Spacer()
            }
            .font(.pretendard(size: 14, weight: .bold))
            .padding(12)
            .background(ColorConstants.gray5)
            .cornerRadius(4)
            .padding(.horizontal, 24)
          }
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
  
  /// Challenge Generate Alert View
  struct ChallengeGenerateResultAlertView: View {
    let store: StoreOf<GenerateRoomCore>
    
    var body: some View {
      WithViewStore(store, observe: { $0 }) { viewStore in
        VStack(spacing: 16) {
          Text(viewStore.alertTitle)
            .font(.pretendard(size: 18, weight: .bold))
            .multilineTextAlignment(.center)
          
          Button {
            viewStore.send(.alertAction(.dismiss))
          } label: {
            Text("확인")
              .frame(maxWidth: .infinity)
              .font(.pretendard(size: 16, weight: .medium))
          }
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .background(ColorConstants.primary)
          .cornerRadius(8)
        }
        .foregroundColor(Color.black)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .frame(width: 250)
      }
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

struct ChallengeTargetMoneyView: View {
  var isSelection: Bool
  let amount: TargetMoneyAmount
  
  var body: some View {
    Text(amount.description)
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
}

struct ChallengeCategoryView: View {
  var isSelection: Bool
  let category: ChallengeCategory
  
  var body: some View {
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
    .foregroundColor(
      isSelection ? ColorConstants.primary : ColorConstants.gray4
    )
  }
}

#Preview {
  GenerateRoomScene.ChallengeGenerateResultAlertView(
    store: Store(
      initialState: GenerateRoomCore.State(alertTitle: "챌린지가 만들어졌어요!"),
      reducer: { GenerateRoomCore() }
    )
  )
  .shadow(radius: 10)
}
