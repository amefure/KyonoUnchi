//
//  SCWeekDayRepository.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import UIKit
import Combine

class SCWeekDayRepository {
    
    public var currentDates: AnyPublisher<[SCDate], Never> {
        _currentDates.eraseToAnyPublisher()
    }
    private let _currentDates = CurrentValueSubject<[SCDate], Never>([])
    
    /// カレンダー
    private let calendar = Calendar(identifier: .gregorian)
    
    init() {
        // カレンダー更新
        updateCalendar()
    }
    
    public func updateCalendar() {
        let df = DateFormatUtility()
        let poopRepository = PoopRepository()
        
        let today = Date()
        var datesList: [SCDate] = []
        for index in 0..<7 {
            let resultDate = df.calcDate(date: today, value: -index)
            let c =  df.convertDateComponents(date: resultDate)
            
            guard let year = c.year,
                  let month = c.month,
                  let day = c.day else {
                 continue
            }

            let dayOfWeek = calendar.component(.weekday, from: resultDate)
            let week = SCWeek(rawValue: dayOfWeek - 1)!
            let isToday = df.checkInSameDayAs(date: resultDate, sameDay: Date())
            let holidayName = "" // ここに祝日名を取得する処理を追加する
            // 表示するカウントを取得
            let count = poopRepository.getTheDateCount(date: resultDate)
            let scDate = SCDate(year: year, month: month, day: day, date: resultDate, week: week, holidayName: holidayName, count: count, isToday: isToday)
            datesList.append(scDate)
        }
        _currentDates.send(datesList.reversed())
    }
}
