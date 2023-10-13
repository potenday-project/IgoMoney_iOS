//
//  CalendarCore.swift
//  igoMoney
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

import ComposableArchitecture

struct CalendarCore: Reducer {
  struct State: Equatable {
    let calendar: Calendar = {
      var calendar = Calendar.current
      calendar.locale = Locale(identifier: "ko-KR")
      return calendar
    }()
    
    var selectedDate: IGODate?
    var currentDate = Date()
    var originDates: [IGODate] = []
    var allDates: [[IGODate]] = []
    var weekCategory: [String] = []
    
    var selectedDayRange: [IGODate] {
      var dates: [IGODate] = []
      
      if let selectedDate = selectedDate,
         let firstIndex = originDates.firstIndex(of: selectedDate) {
        dates.append(selectedDate)
        
        var front = 1
        
        while front != 8 {
          if firstIndex + front >= 30 {
            return []
          }
          let next = originDates[firstIndex + front]
          dates.append(next)
          front += 1
        }
        
        return dates
      }
      
      return []
    }
    
    
    init() {
      self.selectedDate = nil
      self.originDates = getOriginFormatDates()
      self.allDates = getAllDates(to: originDates)
      self.weekCategory = getWeekCategory()
    }
    
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
      
      func toDate() -> Date {
        let currentYear = Calendar.current.component(.year, from: Date())
        var components = DateComponents()
        components.year = currentYear
        components.month = month
        components.day = day
        
        return components.date ?? (Date() + 1)
      }
    }
  }
  
  enum Action: Equatable {
    case selectDate(State.IGODate)
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .selectDate(let selectDate):
      state.selectedDate = selectDate
      return .none
    default:
      return .none
    }
  }
}

private extension CalendarCore.State {
  func getAllDates(to originDates: [IGODate]) -> [[IGODate]] {
    let formattedDates = makeFormat(to: originDates)
    return formattedDates
  }
  
  func getOriginFormatDates() -> [IGODate] {
    let originDates = getOriginDates()
    let convertDates = convertValues(to: originDates)
    return convertDates
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
  
  func convertValues(to values: [Date]) -> [IGODate] {
    var models: [IGODate] = []
    let currentDate = Date()
    
    guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate),
          let endDate = calendar.date(byAdding: .day, value: 7, to: nextDate) else {
      return []
    }
    
    print(nextDate)
    
    for date in values {
      let components = calendar.dateComponents([.month, .day], from: date)
      let isAvailable = (currentDate...endDate) ~= date
      let decodeModel = IGODate(to: components, isAvailable: isAvailable)
      models.append(decodeModel)
    }
    
    return models
  }
  
  func getOriginDates() -> Array<Date> {
    var dates: [Date] = []
    let currentDate = Date()
    
    guard let weekDay = calendar.dateComponents([.weekday], from: currentDate).weekday,
          let startDate = calendar.date(byAdding: .day, value: -weekDay + 1, to: currentDate) else {
      return []
    }
    
    guard let endDate = calendar.date(byAdding: .month, value: 1, to: startDate),
          let weekDayEnd = calendar.dateComponents([.weekday], from: endDate).weekday,
          let realEndDate = calendar.date(byAdding: .day, value: 7 - weekDayEnd, to: endDate) else {
      return []
    }
    
    var tempDate = startDate
    
    while tempDate <= realEndDate {
      dates.append(tempDate)
      guard let newDate = calendar.date(byAdding: .day, value: 1, to: tempDate) else {
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
}

