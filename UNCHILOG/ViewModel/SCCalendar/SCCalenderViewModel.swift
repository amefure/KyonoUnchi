//
//  SCCalenderViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import SwiftUI

class SCCalenderViewModel: ObservableObject {
    
    static let shared = SCCalenderViewModel()
    
    static let START_YEAR = 2000
    static let START_MONTH = 1
    
    /// 表示している年月の日付オブジェクト
    @Published var currentDate: [SCDate] = []
    /// 表示している年月オブジェクト
    @Published var currentYearAndMonth: SCYearAndMonth? = nil
    /// 表示している曜日配列(順番はUIに反映される)
    @Published var dayOfWeekList: [SCWeek] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    
    /// 当日の日付情報
    public let today: DateComponents
    
    /// カレンダー
    private let calendar = Calendar(identifier: .gregorian)
    /// 表示可能な年月配列
    private var selectYearAndMonth: [SCYearAndMonth] = []
    /// 表示している年月オブジェクトIndez
    private var currentYearAndMonthIndex: Int = 0
    
    
    // MARK: Config
    /// 最初に表示したい曜日
    private var initWeek: SCWeek = .sunday
    
    
    init() {
        
        today = calendar.dateComponents([.year, .month, .day], from: Date())
        let nowYear = today.year ?? Self.START_YEAR
        let nowMonth = today.month ?? Self.START_MONTH

        
        setSelectYearAndMonth(startYear: Self.START_YEAR, endYear: nowYear)
        currentYearAndMonthIndex = selectYearAndMonth.firstIndex(where: { $0.year == nowYear && $0.month == nowMonth }) ?? selectYearAndMonth.count - 1
        currentYearAndMonth = selectYearAndMonth[safe: currentYearAndMonthIndex]
        
        setFirstWeek(.saturday)
        
        updateCalendar()
    }
}


extension SCCalenderViewModel {
    
    /// 指定した年月の範囲の`SCYearAndMonth`オブジェクトを生成
    /// - parameter startYear: 開始年月
    /// - parameter endYear: 終了年月
    private func setSelectYearAndMonth(startYear: Int, endYear: Int) {
        var yearMonthList: [SCYearAndMonth] = []
        
        for year in startYear...endYear {
            for month in 1...12 {
                yearMonthList.append(SCYearAndMonth(year: year, month: month))
            }
        }
        selectYearAndMonth = yearMonthList
    }
    
    /// カレンダーUIを更新
    private func updateCalendar() {
        guard let year = currentYearAndMonth?.year,
        let month = currentYearAndMonth?.month else {
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
        for i in 1...range.count {
            components.year = year
            components.month = month
            components.day = i
            guard let date = calendar.date(from: components) else {
                continue
            }
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            df.locale = Locale(identifier: "ja_JP")
            df.calendar = Calendar(identifier: .japanese)
            let dayOfWeek = calendar.component(.weekday, from: date)
            let week = SCWeek(rawValue: dayOfWeek - 1)!
            
            let holidayName = "" // ここに祝日名を取得する処理を追加する
            
            let scDate = SCDate(date: i, week: week, holidayName: holidayName)
            dates.append(scDate)
        }
        
        let firstWeek = dayOfWeekList.firstIndex(of: dates.first!.week)!
        let initWeek = dayOfWeekList.firstIndex(of: initWeek)!
        let subun = abs(firstWeek - initWeek)
    
        
        if subun != 0 {
            for _ in 0..<subun {
                let scDate = SCDate(date: -1, week: .friday, holidayName: "")
                dates.insert(scDate, at: 0)
            }
        }
        
        if dates.count % 7 != 0 {
            let space = 7 - dates.count % 7
            for _ in 0..<space {
                let scDate = SCDate(date: -1, week: .friday, holidayName: "")
                dates.append(scDate)
            }
        }
        currentDate = dates
    }
}


extension SCCalenderViewModel {
        
    /// 年月を1つ進める
    public func forwardMonth() {
        currentYearAndMonthIndex += 1
        guard let nextYearAndMonth = selectYearAndMonth[safe: currentYearAndMonthIndex] else {
            currentYearAndMonthIndex -= 1
            return
        }
        currentYearAndMonth = nextYearAndMonth
        updateCalendar()
    }

    /// 年月を1つ戻す
    public func backMonth() {
        currentYearAndMonthIndex -= 1
        guard let nextYearAndMonth = selectYearAndMonth[safe: currentYearAndMonthIndex] else {
            currentYearAndMonthIndex += 1
            return
        }
        currentYearAndMonth = nextYearAndMonth
        updateCalendar()
    }

    /// 最初に表示したい曜日を設定
    /// - parameter week: 開始曜日
    public func setFirstWeek(_ week: SCWeek) {
        initWeek = week
        dayOfWeekList.moveWeekToFront(initWeek)
        updateCalendar()
    }

}
