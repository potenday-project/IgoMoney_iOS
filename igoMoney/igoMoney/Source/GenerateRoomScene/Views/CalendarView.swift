////
////  CalendarView.swift
////  igoMoney
////
////  Copyright (c) 2023 Minii All rights reserved.
//
//import SwiftUI
//
//import ComposableArchitecture
//
//struct CalendarView: View {
////  let store: StoreOf<CalendarCore>
//  
//  struct CalendarSelectModifier: ViewModifier {
//    let isFirst: Bool
//    let isLast: Bool
//    
//    func body(content: Content) -> some View {
//      content
//        .cornerRadius(isFirst ? .infinity : .zero, corner: .topLeft)
//        .cornerRadius(isFirst ? .infinity : .zero, corner: .bottomLeft)
//        .cornerRadius(isLast ? .infinity : .zero, corner: .topRight)
//        .cornerRadius(isLast ? .infinity : .zero, corner: .bottomRight)
//    }
//  }
//  
//  var body: some View {
//    VStack(spacing: 4) {
//      HStack(spacing: .zero) {
//        WithViewStore(store, observe: { $0.weekCategory }) { categories in
//          ForEach(categories.state, id: \.self) { category in
//            Text(category)
//              .foregroundColor(
//                category == "일" ?
//                Color.red : category == "토" ?
//                Color.blue : .black
//              )
//              .font(.pretendard(size: 14, weight: .medium))
//              .frame(width: 30, height: 30)
//              .padding(8)
//          }
//        }
//      }
//      
//      Divider()
//        .padding(.horizontal, 16)
//      
//      WithViewStore(store, observe: { $0 }) { viewStore in
//        ForEach(0..<viewStore.allDates.count, id: \.self) { row in
//          HStack(spacing: .zero) {
//            ForEach(0..<viewStore.allDates[row].count, id: \.self) { column in
//              let date = viewStore.allDates[row][column]
//              let day = date.day
//              let isFirst = viewStore.selectedDayRange.first == date
//              let isLast = viewStore.selectedDayRange.last == date
//              
//              Text(day.description)
//                .font(.pretendard(size: 14, weight: .medium))
//                .foregroundColor(
//                  viewStore.selectedDate == date ? Color.white : date.isAvailable ? .black : ColorConstants.gray4
//                  
//                )
//                .disabled(date.isAvailable == false)
//                .frame(width: 30, height: 30)
//                .padding(.vertical, 4)
//                .padding(.horizontal, 8)
//                .background(
//                  viewStore.selectedDayRange.contains(date) ?
//                  ColorConstants.primary : Color.clear
//                )
//                .modifier(
//                  CalendarSelectModifier(
//                    isFirst: isFirst,
//                    isLast: isLast
//                  )
//                )
//                .onTapGesture {
//                  if date.isAvailable {
//                    viewStore.send(.selectDate(date))
//                  }
//                }
//            }
//          }
//        }
//      }
//    }
//  }
//}
