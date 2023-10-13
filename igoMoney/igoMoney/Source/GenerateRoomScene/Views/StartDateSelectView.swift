//
//  StartDateSelectView.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

import ComposableArchitecture

struct StartDateSelectView: View {
  var body: some View {
    VStack(alignment: .center, spacing: 24) {
      VStack(spacing: .zero) {
        HStack {
          Text("챌린지 시작일 선택")
          
          Spacer()
        }
        .font(.pretendard(size: 18, weight: .bold))
        .padding(.bottom, 4)
        
        HStack {
          Text("챌린지 시작일을 선택하면 종료일은 자동 선택됩니다.")
          
          Spacer()
        }
        .font(.pretendard(size: 14, weight: .medium))
        .foregroundColor(ColorConstants.gray2)
        
      }
      .frame(maxWidth: .infinity)
      
      CalendarView(
        store: Store(
          initialState: CalendarCore.State(),
          reducer: { CalendarCore()._printChanges() }
        )
      )
      .padding(.vertical, 8)
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
}

#Preview {
  StartDateSelectView()
}
