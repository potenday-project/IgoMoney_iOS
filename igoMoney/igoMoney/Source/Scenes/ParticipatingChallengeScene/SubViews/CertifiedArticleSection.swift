//
//  CertifiedArticleSection.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct CertifiedArticleSection: View {
  @ViewBuilder
  private func ChallengeClassificationButton(
    title: String,
    isSelected: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button {
      action()
    } label: {
      Text(title)
        .padding(.vertical, 8)
    }
    .buttonStyle(.plain)
    .foregroundColor(isSelected ? Color.black : ColorConstants.gray3)
    .frame(maxWidth: .infinity)
    .overlay(
      Rectangle()
        .frame(height: 1.5)
        .foregroundColor(isSelected ? Color.black : ColorConstants.gray3)
      , alignment: .bottom
    )
  }
  
  var body: some View {
    ZStack {
      Color.white.edgesIgnoringSafeArea(.all)
      
      VStack(spacing: 24) {
        HStack(spacing: 16) {
          ChallengeClassificationButton(
            title: "나의 챌린지",
            isSelected: true
          ) {
            print("Tapped 나의 챌린지")
          }
          
          ChallengeClassificationButton(
            title: "상대방 챌린지",
            isSelected: false
          ) {
            print("Tapped 상대방 챌린지")
          }
        }
        .padding(.top, 20)
        .font(.pretendard(size: 16, weight: .bold))
        
        CertifiedDateSelectView()
        
        Spacer()
      }
      .padding(.horizontal, 24)
    }
    .cornerRadius(20, corner: .topLeft)
    .cornerRadius(20, corner: .topRight)
  }
}

struct CertifiedDateSelectView: View {
  @State private var selectedDate: Date
  private let startDate = Date()
  private var challengeRange: [Date] = []
  
  init() {
    self._selectedDate = State(initialValue: Date())
    self.challengeRange = generateChallengeRange()
  }
  
  private func generateChallengeRange() -> [Date] {
    let valueRange = (0...6)
    let calendar = Calendar.current
    let days = valueRange.map {
      return calendar.date(byAdding: .day, value: $0, to: startDate) ?? Date()
    }
    return days
  }
  
  private func equalDate(lhs: Date, rhs: Date) -> Bool {
    return lhs.toString(with: "M/dd") == rhs.toString(with: "M/dd")
  }
  
  @ViewBuilder
  private func DateSelectButton(index: Int, to date: Date) -> some View {
    VStack(spacing: 8) {
      Text(date.toString(with: "M/dd"))
        .font(.pretendard(size: 12, weight: .medium))
      
      Text((index + 1).description + "일차")
        .font(.pretendard(size: 14, weight: .semiBold))
      
      Image(systemName: "checkmark.circle")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20)
    }
  }
  
  var body: some View {
    VStack(spacing: 12) {
      HStack {
        Text("🔥 9월 24일 일요일 1일차")
        
        Spacer()
      }
      .font(.pretendard(size: 18, weight: .bold))
      
      HStack(spacing: .zero) {
        ForEach(0..<challengeRange.count, id: \.self) { index in
          let date = challengeRange[index]
          
          ZStack {
            if equalDate(lhs: date, rhs: selectedDate) {
              RoundedRectangle(cornerRadius: 8)
                .fill(ColorConstants.primary7)
                .transition(.scale)
            }
            
            DateSelectButton(index: index, to: date)
              .padding(.vertical, 8)
          }
          .frame(maxWidth: .infinity, maxHeight: 100)
          .onTapGesture {
            withAnimation {
              self.selectedDate = date
            }
          }
        }
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(Color.white)
      .cornerRadius(8)
      .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
      
      CertifyButton(selectedDate: $selectedDate)
    }
  }
}

struct CertifyButton: View {
  @Binding var selectedDate: Date
  
  var body: some View {
    Button {
      
    } label: {
      HStack {
        VStack(alignment: .leading, spacing: .zero) {
          Text(selectedDate.toString(with: "M월 dd일"))
            .font(.pretendard(size: 12, weight: .medium))
          
          Text("오늘 하루 지출 내역 인증하기")
            .font(.pretendard(size: 16, weight: .bold))
        }
        
        Spacer()
        
        Image("icon_add_task")
      }
    }
    .buttonStyle(.plain)
    .padding(16)
    .background(ColorConstants.primary8)
    .cornerRadius(10)
    .shadow(color: ColorConstants.gray5, radius: 4, y: 2)
  }
}

#Preview {
  CertifiedArticleSection()
    .padding()
    .background(ColorConstants.gray4)
}
