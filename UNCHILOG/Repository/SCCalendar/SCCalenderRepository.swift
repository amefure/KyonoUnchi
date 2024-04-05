//
//  SCCalenderViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import SwiftUI
import Combine

class SCCalenderRepository {
    
    static let shared = SCCalenderRepository()

    // MARK: Config
    static let START_YEAR = 2023
    static let START_MONTH = 1
    /// 最初に表示したい曜日
    private var initWeek: SCWeek = .sunday

    
    /// 表示している年月の日付オブジェクト
    public var currentDates: AnyPublisher<[SCDate], Never> {
        _currentDates.eraseToAnyPublisher()
    }
    private let _currentDates = CurrentValueSubject<[SCDate], Never>([])
    
    /// 表示している年月オブジェクト
    public var currentYearAndMonth: AnyPublisher<SCYearAndMonth?, Never> {
        _currentYearAndMonth.eraseToAnyPublisher()
    }
    private let _currentYearAndMonth = CurrentValueSubject<SCYearAndMonth?, Never>(nil)
    
    /// 表示している曜日配列(順番はUIに反映される)
    public var dayOfWeekList: AnyPublisher<[SCWeek], Never> {
        _dayOfWeekList.eraseToAnyPublisher()
    }
    private let _dayOfWeekList = CurrentValueSubject<[SCWeek], Never>([.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])
    
    /// 表示可能な年月配列
    public var selectYearAndMonth: [SCYearAndMonth] = []
    
    /// 当日の日付情報
    private let today: DateComponents
    
    /// カレンダー
    private let calendar = Calendar(identifier: .gregorian)
    /// 表示している年月オブジェクトIndex
    private var currentYearAndMonthIndex: Int = 0
    
    
    init(startYear: Int = START_YEAR, startMonth: Int = START_MONTH, initWeek: SCWeek = .sunday) {
        
        self.initWeek = initWeek
        
        today = calendar.dateComponents([.year, .month, .day], from: Date())
        let nowYear = today.year ?? startYear
        let nowMonth = today.month ?? startMonth

        // 表示可能な年月情報を生成し保持
        setSelectYearAndMonth(startYear: startYear, endYear: nowYear)
        // カレンダーの初期表示位置
        moveYearAndMonthCalendar(year: nowYear, month: nowMonth)
        // 週の始まりに設定する曜日を指定
        setFirstWeek(initWeek)
        // カレンダー更新
        updateCalendar()
    }
}


extension SCCalenderRepository {
    
    /// 指定した年月の範囲の`SCYearAndMonth`オブジェクトを生成
    /// - parameter startYear: 開始年月
    /// - parameter endYear: 終了年月
    private func setSelectYearAndMonth(startYear: Int, endYear: Int) {
        var yearMonthList: [SCYearAndMonth] = []
        // 当年+1年先のカレンダー情報を取得しておく
        for year in startYear...endYear + 1 {
            for month in 1...12 {
                yearMonthList.append(SCYearAndMonth(year: year, month: month))
            }
        }
        selectYearAndMonth = yearMonthList
    }
    
    /// カレンダーUIを更新
    /// 日付情報を取得して配列に格納
    private func updateCalendar() {
        guard let year = _currentYearAndMonth.value?.year,
        let month = _currentYearAndMonth.value?.month else {
            return
        }
        
        // 指定された年月の最初の日を取得
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let startDate = calendar.date(from: components) else {
            return
        }
        
        // 指定された年月の日数を取得
        guard let range = calendar.range(of: .day, in: .month, for: startDate) else {
            return
        }
        
        
        // 日にち情報を格納する配列を準備
        var dates: [SCDate] = []
        
        // 月の初めから最後の日までループして日にち情報を作成
        for day in 1...range.count {
            components.year = year
            components.month = month
            components.day = day
            guard let date = calendar.date(from: components) else {
                continue
            }
            let dayOfWeek = calendar.component(.weekday, from: date)
            let week = SCWeek(rawValue: dayOfWeek - 1)!
            
            let holidayName = "" // ここに祝日名を取得する処理を追加する
            let scDate = SCDate(year: year, month: month, day: day, date: date,week: week, holidayName: holidayName)
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
        _currentDates.send(dates)
    }
}


extension SCCalenderRepository {
        
    /// 年月を1つ進める
    /// - Returns: 成功フラグ
    public func forwardMonth() -> Bool {
        currentYearAndMonthIndex += 1
        guard let nextYearAndMonth = selectYearAndMonth[safe: currentYearAndMonthIndex] else {
            currentYearAndMonthIndex -= 1
            return false
        }
        _currentYearAndMonth.send(nextYearAndMonth)
        updateCalendar()
        return true
    }

    /// 年月を1つ戻す
    /// - Returns: 成功フラグ
    public func backMonth() -> Bool {
        currentYearAndMonthIndex -= 1
        guard let nextYearAndMonth = selectYearAndMonth[safe: currentYearAndMonthIndex] else {
            currentYearAndMonthIndex += 1
            return false
        }
        _currentYearAndMonth.send(nextYearAndMonth)
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
        currentYearAndMonthIndex = selectYearAndMonth.firstIndex(where: { $0.year == year && $0.month == month }) ?? selectYearAndMonth.count - 1
        _currentYearAndMonth.send(selectYearAndMonth[safe: currentYearAndMonthIndex])
        updateCalendar()
    }
}
