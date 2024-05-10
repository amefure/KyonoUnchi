//
//  SCCalenderViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import SwiftUI
import Combine

class SCCalenderRepository {

    // MARK: Config
    // 初期表示位置デモ値
    static let START_YEAR = 2023
    static let START_MONTH = 1
    /// 最初に表示したい曜日
    private var initWeek: SCWeek = .sunday

    /// 表示している前後3ヶ月の年月の日付オブジェクト
    ///  `[[2月の日付情報] , [3月の日付情報] , [4月の日付情報]]`
    ///  `[[] , [1月の日付情報] , [2月の日付情報]]`
    public var currentDates: AnyPublisher<[[SCDate]], Never> {
        _currentDates.eraseToAnyPublisher()
    }
    private let _currentDates = CurrentValueSubject<[[SCDate]], Never>([])
    
    /// 表示している前後3ヶ月の年月オブジェクト
    ///  `[2024.2 , 2024.3 , 2024.4]`
    public var currentYearAndMonth: AnyPublisher<[SCYearAndMonth], Never> {
        _currentYearAndMonth.eraseToAnyPublisher()
    }
    private let _currentYearAndMonth = CurrentValueSubject<[SCYearAndMonth], Never>([])
    
    /// 表示している曜日配列(順番はUIに反映される)
    public var dayOfWeekList: AnyPublisher<[SCWeek], Never> {
        _dayOfWeekList.eraseToAnyPublisher()
    }
    private let _dayOfWeekList = CurrentValueSubject<[SCWeek], Never>([.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])
    
    /// 当日の日付情報
    private let today: DateComponents
    
    /// カレンダー
    private let calendar = Calendar(identifier: .gregorian)
    
    
    init(startYear: Int = START_YEAR, startMonth: Int = START_MONTH, initWeek: SCWeek = .sunday) {
        
        self.initWeek = initWeek
        
        today = calendar.dateComponents([.year, .month, .day], from: Date())
        let nowYear = today.year ?? startYear
        let nowMonth = today.month ?? startMonth

        // カレンダーの初期表示位置
        moveYearAndMonthCalendar(year: nowYear, month: nowMonth)
        // 週の始まりに設定する曜日を指定
        setFirstWeek(initWeek)
        // カレンダー更新
        updateCalendar()
    }
}


extension SCCalenderRepository {
    
    /// カレンダーUIを更新
    /// 日付情報を取得して配列に格納
    public func updateCalendar() {
        let yearAndMonths = _currentYearAndMonth.value
        
        let df = DateFormatUtility()
        let poopRepository = PoopRepository()
        
        var datesList: [[SCDate]] = []
        for yearAndMonth in yearAndMonths {
            let year = yearAndMonth.year
            let month = yearAndMonth.month
            
            // 指定された年月の最初の日を取得
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1
            guard let startDate = calendar.date(from: components) else {
                datesList.append([])
                continue
            }
            
            // 指定された年月の日数を取得
            guard let range = calendar.range(of: .day, in: .month, for: startDate) else {
                datesList.append([])
                continue
            }
            
            
            // 日にち情報を格納する配列を準備
            var dates: [SCDate] = []
            
            // 月の初めから最後の日までループして日にち情報を作成
            for day in 1...range.count {
                components.year = year
                components.month = month
                components.day = day
                guard let date = calendar.date(from: components) else {
                    datesList.append([])
                    continue
                }
                let dayOfWeek = calendar.component(.weekday, from: date)
                let week = SCWeek(rawValue: dayOfWeek - 1)!
                let isToday = df.checkInSameDayAs(date: date, sameDay: Date())
                let holidayName = "" // ここに祝日名を取得する処理を追加する
                // 表示するカウントを取得
                let count = poopRepository.getTheDateCount(date: date)
                let scDate = SCDate(year: year, month: month, day: day, date: date, week: week, holidayName: holidayName, count: count, isToday: isToday)
                dates.append(scDate)
            }
            
            let firstWeek = _dayOfWeekList.value.firstIndex(of: dates.first!.week!)!
            let initWeek = _dayOfWeekList.value.firstIndex(of: initWeek)!
            let subun = abs(firstWeek - initWeek)
        
            
            if subun != 0 {
                for _ in 0..<subun {
                    let blankScDate = SCDate(year: -1, month: -1, day: -1)
                    dates.insert(blankScDate, at: 0)
                }
            }
            
            if dates.count % 7 != 0 {
                let space = 7 - dates.count % 7
                for _ in 0..<space {
                    let blankScDate = SCDate(year: -1, month: -1, day: -1)
                    dates.append(blankScDate)
                }
            }
            datesList.append(dates)
        }
        _currentDates.send(datesList)
    }
}


extension SCCalenderRepository {
        
    /// 年月を1つ進める
    /// - Returns: 成功フラグ
    public func forwardMonth() -> Bool {
        
        var value = _currentYearAndMonth.value
        guard let last = value.last else { return false }
        if last.month + 1 == 13 {
            value.removeFirst()
            value.append(SCYearAndMonth(year: last.year + 1, month: 1))
        } else {
            value.removeFirst()
            value.append(SCYearAndMonth(year: last.year, month: last.month + 1))
        }
        _currentYearAndMonth.send(value)
        updateCalendar()
        return true
    }

    /// 年月を1つ戻す
    /// - Returns: 成功フラグ
    public func backMonth() -> Bool {
        var value = _currentYearAndMonth.value
        guard let first = value.first else { return false }
        if first.month - 1 == 0 {
            value.removeLast()
            value.insert(SCYearAndMonth(year: first.year - 1, month: 12), at: 0)
        } else {
            value.removeLast()
            value.insert(SCYearAndMonth(year: first.year, month: first.month - 1), at: 0)
        }
        _currentYearAndMonth.send(value)
        updateCalendar()
        return true
    }

    /// 最初に表示したい曜日を設定
    /// - parameter week: 開始曜日
    public func setFirstWeek(_ week: SCWeek) {
        initWeek = week
        var list = _dayOfWeekList.value
        list.moveWeekToFront(initWeek)
        _dayOfWeekList.send(list)
        updateCalendar()
    }

    /// カレンダー初期表示年月を指定して更新
    /// - parameter year: 指定年
    /// - parameter month: 指定月
    public func moveYearAndMonthCalendar(year: Int, month: Int) {
        var value: [SCYearAndMonth] = []
        let middle = SCYearAndMonth(year: year, month: month)
        value.append(middle)
        
        if middle.month + 1 == 13 {
            value.append(SCYearAndMonth(year: middle.year + 1, month: 1))
        } else {
            value.append(SCYearAndMonth(year: middle.year, month: middle.month + 1))
        }
        
        if middle.month - 1 == 0 {
            value.insert(SCYearAndMonth(year: middle.year - 1, month: 12), at: 0)
        } else {
            value.insert(SCYearAndMonth(year: middle.year, month: middle.month - 1), at: 0)
        }
        
        _currentYearAndMonth.send(value)
        updateCalendar()
    }
}
