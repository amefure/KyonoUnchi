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

    /// 表示対象として保持している日付オブジェクト
    /// `currentYearAndMonth`の要素番号と紐づく形で日付情報が格納される
    ///  `[[2月の日付情報] , [3月の日付情報] , [4月の日付情報]]`
    public var currentDates: AnyPublisher<[[SCDate]], Never> {
        _currentDates.eraseToAnyPublisher()
    }
    private let _currentDates = CurrentValueSubject<[[SCDate]], Never>([])
    
    /// 表示対象として保持している年月オブジェクト
    ///  `[2024.2 , 2024.3 , 2024.4]`
    /// `forwardMonth / backMonth`を実行するたびに追加されていく
    /// 初期表示時点は
    public var currentYearAndMonth: AnyPublisher<[SCYearAndMonth], Never> {
        _currentYearAndMonth.eraseToAnyPublisher()
    }
    private let _currentYearAndMonth = CurrentValueSubject<[SCYearAndMonth], Never>([])
    
    /// 表示している曜日配列(順番はUIに反映される)
    public var dayOfWeekList: AnyPublisher<[SCWeek], Never> {
        _dayOfWeekList.eraseToAnyPublisher()
    }
    private let _dayOfWeekList = CurrentValueSubject<[SCWeek], Never>([.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday])
    
    /// アプリに表示中の年月インデックス
    public var displayCalendarIndex: AnyPublisher<Int, Never> {
        _displayCalendarIndex.eraseToAnyPublisher()
    }
    private let _displayCalendarIndex = CurrentValueSubject<Int, Never>(0)
    
    /// 当日の日付情報
    private let today: DateComponents
    
    /// カレンダー
    private let calendar = Calendar(identifier: .gregorian)
    
    
    init(startYear: Int = START_YEAR, startMonth: Int = START_MONTH, initWeek: SCWeek = .sunday) {
        
        self.initWeek = initWeek
        
        today = calendar.dateComponents([.year, .month, .day], from: Date())
        let nowYear: Int = today.year ?? startYear
        let nowMonth: Int = today.month ?? startMonth

        // カレンダーの初期表示用データのセットアップ
        initialSetUpCalendarData(year: nowYear, month: nowMonth)
        // 週の始まりに設定する曜日を指定
        setFirstWeek(initWeek)
        // カレンダー更新
        updateCalendar()
    }
}

// MARK: Private
extension SCCalenderRepository {
    
    /// カレンダー初期格納年月を指定して更新（前後rangeヶ月分を含める）
    /// - Parameters:
    ///   - year: 当日の指定年
    ///   - month: 中央となる指定月
    ///   - range: 中央を基準に前後に含める月数（例: range = 1なら前後1ヶ月ずつ）
    private func initialSetUpCalendarData(year: Int, month: Int, range: Int = 5) {
        let middle = SCYearAndMonth(year: year, month: month)
        var yearAndMonths: [SCYearAndMonth] = []
        
        let dateComponents = DateComponents(year: middle.year, month: middle.month)
        // 範囲内の前後SCYearAndMonthを生成して追加
        for offset in (-range)...range {
            guard let newDate = calendar.date(from: dateComponents),
                  let targetDate = calendar.date(byAdding: .month, value: offset, to: newDate) else { continue }
            let components = calendar.dateComponents([.year, .month], from: targetDate)
            guard let y = components.year,
                    let m = components.month else { continue }
            yearAndMonths.append(SCYearAndMonth(year: y, month: m))
        }
        
        // 中央に指定しているインデックス番号を取得
        let index: Int = yearAndMonths.firstIndex(where: { $0.yearAndMonth == middle.yearAndMonth }) ?? 0
        _displayCalendarIndex.send(index)

        _currentYearAndMonth.send(yearAndMonths)
        updateCalendar()
    }
}


extension SCCalenderRepository {
    
    /// カレンダーUIを更新
    /// `currentYearAndMonth`を元に日付情報を取得して配列に格納
    public func updateCalendar() {
        let yearAndMonths = _currentYearAndMonth.value
        
        let df = DateFormatUtility()
        let poopRepository = PoopRepository()
        
        var datesList: [[SCDate]] = []
        for yearAndMonth in yearAndMonths {
            let year: Int = yearAndMonth.year
            let month: Int = yearAndMonth.month
            
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
                let isToday: Bool = df.checkInSameDayAs(date: date, sameDay: Date())
                let holidayName = "" // ここに祝日名を取得する処理を追加する
                // 表示するカウントを取得
                let count: Int = poopRepository.getTheDateCount(date: date)
                let scDate = SCDate(
                    year: year,
                    month: month,
                    day: day,
                    date: date,
                    week: week,
                    holidayName: holidayName,
                    count: count,
                    isToday: isToday
                )
                dates.append(scDate)
            }
            
            guard let week = dates.first?.week else { return }
            
            let firstWeek: Int = _dayOfWeekList.value.firstIndex(of: week) ?? 0
            let initWeek: Int = _dayOfWeekList.value.firstIndex(of: initWeek) ?? 0
            let subun: Int = abs(firstWeek - initWeek)
        
            
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
        
    /// 格納済みの最新月の翌月を1ヶ月分追加する
    /// - Returns: 成功フラグ
    public func addNextMonth() -> Bool {
        
        var value = _currentYearAndMonth.value
        guard let last = value.last else { return false }
        if last.month + 1 == 13 {
            value.append(SCYearAndMonth(year: last.year + 1, month: 1))
        } else {
            value.append(SCYearAndMonth(year: last.year, month: last.month + 1))
        }
        _currentYearAndMonth.send(value)
        updateCalendar()
        return true
    }

    /// 格納済みの最古月の前月を12ヶ月分追加する
    /// - Returns: 成功フラグ
    public func addPreMonth() -> Bool {
        var value = _currentYearAndMonth.value
        // 12ヶ月分一気に追加する
        for _ in 1..<12 {
            guard let first = value.first else { return false }
            if first.month - 1 == 0 {
                value.insert(SCYearAndMonth(year: first.year - 1, month: 12), at: 0)
            } else {
                value.insert(SCYearAndMonth(year: first.year, month: first.month - 1), at: 0)
            }
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
}
