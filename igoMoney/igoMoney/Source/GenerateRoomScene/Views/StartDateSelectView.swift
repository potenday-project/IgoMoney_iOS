//
//  StartDateSelectView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct StartDateSelectView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 24) {
      VStack(spacing: .zero) {
        HStack {
          Text("챌린지 시작일 선택")
          
          Spacer()
        }
        .font(.pretendard(size: 18, weight: .bold))
        
        HStack {
          Text("챌린지 시작일을 선택하면 종료일은 자동 선택됩니다.")
          
          Spacer()
        }
        .font(.pretendard(size: 14, weight: .medium))
        .foregroundColor(ColorConstants.gray2)
        
      }
      .frame(maxWidth: .infinity)
      
      DatePicker(
        selection: .constant(Date()),
        in: calculateAvaliableRange(),
        displayedComponents: .date
      ) {
        EmptyView()
          .frame(height: .zero)
      }
      .environment(\.locale, Locale(identifier: "ko-KR"))
      .datePickerStyle(.graphical)
      .padding(16)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .foregroundColor(.white)
          .shadow(color: ColorConstants.gray.opacity(0.1), radius: 8, y: 2)
      )
      
      Button {
        
      } label: {
        Text("확인")
          .font(.pretendard(size: 18, weight: .medium))
          .frame(maxWidth: .infinity)
      }
      .padding(16)
      .background(ColorConstants.primary)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
    .padding(.horizontal, 24)
  }
  
  private func calculateAvaliableRange() -> ClosedRange<Date> {
    let calendar = Calendar.current
    
    let now = Date()
    
    if let nextDay = calendar.date(byAdding: .day, value: 1, to: now) {
      if let closeDay = calendar.date(byAdding: .day, value: 7, to: nextDay) {
        return (nextDay...closeDay)
      }
    }
    
    return (Date()...Date())
  }
}

#Preview {
  StartDateSelectView()
}
