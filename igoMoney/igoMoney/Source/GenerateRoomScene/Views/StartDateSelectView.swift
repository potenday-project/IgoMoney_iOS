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
        .padding(.bottom, 4)
        
        HStack {
          Text("챌린지 시작일을 선택하면 종료일은 자동 선택됩니다.")
          
          Spacer()
        }
        .font(.pretendard(size: 14, weight: .medium))
        .foregroundColor(ColorConstants.gray2)
        
      }
      .frame(maxWidth: .infinity)
      
      CalendarTemplate()
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

/*
 1. 현재 날짜를 기준으로 가능한 날짜를 뽑아낸다. (다음날 부터 1주일)
 2. 가능한 날짜들 중, 선택한 날짜를 업데이트 한다.
 3. 선택된 날짜부터 대결 기간을 계산한다.
 4. 대결 기간 내에 있는 날짜들의 백그라운드를 변경한다.
 */

struct IGODate: Identifiable, Hashable {
  let id = UUID()
  let month: Int
  let day: Int
  var isAvailable: Bool = true
  
  init(to components: DateComponents, isAvailable: Bool) {
    if let month = components.month {
      self.month = month
    } else {
      month = .zero
    }
    
    if let day = components.day {
      self.day = day
    } else {
      self.day = .zero
    }
    
    self.isAvailable = isAvailable
  }
}

/*
 1. 보여줄 날짜 데이터를 계산한다.
 2. 보여줄 수 있는 날짜 데이터를 커스텀 데이터 타입으로 변경한다.
 3. 커스텀 데이터의 배열 형식을 변경한다.
 */


struct CalendarTemplate: View {
  @State var selectedDate: IGODate?
  
  let currentDate = Date()
  
  var selectedDayRange: [IGODate] {
    var dates: [IGODate] = []
    
    if let selectedDate = selectedDate, 
        let firstIndex = allDates.firstIndex(of: selectedDate) {
      dates.append(selectedDate)
      
      var front = 1
      
      while front != 8 {
        if firstIndex + front >= 30 {
          return []
        }
        let next = allDates[firstIndex + front]
        dates.append(next)
        front += 1
      }
      
      return dates
    }
    
    return []
  }
  
  var allDates: [IGODate] = []
  var dates: [[IGODate]] = []
  
  init() {
    let originAllDates = getAllDates()
    self.allDates = covertValues(to: originAllDates)
    self.dates = makeFormat(to: allDates)
  }
  
  func makeFormat(to values: [IGODate]) -> [[IGODate]] {
    let weekOfMonth = Int(values.count / 7)
    var dates: [[IGODate]] = Array(repeating: [IGODate](), count: weekOfMonth + 1)
    
    for index in 0..<values.count {
      let row = index / 7
      dates[row].append(values[index])
    }
    
    return dates
  }
  
  func covertValues(to values: [Date]) -> [IGODate] {
    var models: [IGODate] = []
    
    guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else {
      return []
    }
    
    guard let endDate = Calendar.current.date(byAdding: .day, value: 7, to: nextDate) else {
      return []
    }
    
    for date in values {
      let components = Calendar.current.dateComponents([.month, .day], from: date)
      let isAvailable = (nextDate...endDate) ~= date
      let decodeModel = IGODate(to: components, isAvailable: isAvailable)
      models.append(decodeModel)
    }
    
    return models
  }
  
  func getAllDates() -> Array<Date> {
    var dates: [Date] = []
    let calendar = Calendar.current
    
    guard let weekDay = calendar.dateComponents([.weekday], from: currentDate).weekday else {
      return []
    }
    
    guard let startDate = calendar.date(byAdding: .day, value: -weekDay + 1, to: currentDate) else {
      return []
    }
    
    guard let endDate = calendar.date(byAdding: .month, value: 1, to: startDate) else {
      return []
    }
    
    guard let weekDayEnd = calendar.dateComponents([.weekday], from: endDate).weekday else {
      return []
    }
    
    guard let realEndDate = calendar.date(byAdding: .day, value: 7 - weekDayEnd, to: endDate) else {
      return []
    }
    
    var tempDate = startDate
    
    while tempDate <= realEndDate {
      dates.append(tempDate)
      guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate) else {
        continue
      }
      
      tempDate = newDate
    }
    
    return dates
  }
  
  func getWeekCategory() -> [String] {
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "ko-KR")
    return calendar.shortWeekdaySymbols
  }
  
  var body: some View {
    VStack(spacing: 4) {
      HStack(spacing: .zero) {
        ForEach(getWeekCategory(), id: \.self) {
          Text($0)
            .foregroundColor($0 == "일" ? Color.red : $0 == "토" ? Color.blue : .black)
            .font(.pretendard(size: 14, weight: .medium))
            .frame(width: 30, height: 30)
            .padding(8)
        }
      }
      
      Divider()
        .padding(.horizontal, 16)
      
      ForEach(0..<dates.count, id: \.self) { row in
        HStack(spacing: .zero) {
          ForEach(0..<dates[row].count, id: \.self) { column in
            let date = dates[row][column]
            let day = date.day
            
            Text(day.description)
              .font(.pretendard(size: 14, weight: .medium))
              .foregroundColor(
                selectedDate == date ? Color.white : date.isAvailable ? .black : ColorConstants.gray4
                
              )
              .disabled(date.isAvailable == false)
              .frame(width: 30, height: 30)
              .padding(.vertical, 4)
              .padding(.horizontal, 8)
              .background(
                selectedDayRange.contains(date) ?
                ColorConstants.primary : Color.clear
              )
              .cornerRadius(
                selectedDayRange.first == date ? .infinity : .zero,
                corner: .topLeft
              )
              .cornerRadius(
                selectedDayRange.first == date ? .infinity : .zero,
                corner: .bottomLeft
              )
              .cornerRadius(
                selectedDayRange.last == date ? .infinity : .zero,
                corner: .topRight
              )
              .cornerRadius(
                selectedDayRange.last == date ? .infinity : .zero,
                corner: .bottomRight
              )
              .onTapGesture {
                if date.isAvailable {
                  selectedDate = date
                }
              }
          }
        }
      }
    }
  }
}

#Preview {
  StartDateSelectView()
}
