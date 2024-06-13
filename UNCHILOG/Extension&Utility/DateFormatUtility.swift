//
//  DateFormatUtility.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit

class DateFormatUtility {
    
    private let df = DateFormatter()
    private var c = Calendar(identifier: .gregorian)
    
    static let today: Date = Date()
    
    init(format: String = "yyyy-MM-dd") {
        df.dateFormat = format
        df.locale = Locale(identifier: "ja_JP")
        c.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        df.calendar = c   
    }
}
    
// MARK: -　DateFormatter
extension DateFormatUtility {
    
    /// `Date`型を受け取り`String`型を返す
    public func getString(date: Date) -> String {
        return df.string(from: date)
    }
    
    /// `String`型を受け取り`Date`型を返す
    public func getDate(str: String) -> Date {
        return df.date(from: str) ?? Date()
    }

}

// MARK: -　Calendar
extension DateFormatUtility {
    
    /// `Date`型を受け取り`DateComponents`型を返す
    /// - Parameters:
    ///   - date: 変換対象の`Date`型
    ///   - components: `DateComponents`で取得したい`Calendar.Component`
    /// - Returns: `DateComponents`
    public func convertDateComponents(date: Date, components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]) -> DateComponents {
        c.dateComponents(components, from: date)
    }
    
    /// `DateComponents`型を受け取り`Date`型を返す
    public func convertDate(components: DateComponents) -> Date {
        c.date(from: components) ?? Date()
    }
    
    /// `Date`型を受け取りその日の00:00:00の`Date`型を返す
    public func startOfDay(_ date: Date) -> Date {
        return c.startOfDay(for: date)
    }
    
    /// 日付時間を23:59:59にリセットして返す
    public func endOfDay(for date: Date) -> Date {
        c.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? DateFormatUtility.today
    }
    
    /// 受け取った日付が指定した日と同じかどうか
    public func checkInSameDayAs(date: Date, sameDay: Date = DateFormatUtility.today) -> Bool {
        // 時間をリセットしておく
        let resetDate = c.startOfDay(for: date)
        let resetToDay = c.startOfDay(for: sameDay)
        return c.isDate(resetDate, inSameDayAs: resetToDay)
    }
    
    /// 受け取った日付が今日とどれだけ離れているか
    public func daysDifferenceFromToday(date: Date) -> Int {
        // 時間をリセットしておく
        let resetDate = c.startOfDay(for: date)
        let resetToDay = c.startOfDay(for: DateFormatUtility.today)
        return c.dateComponents([.day], from: resetDate, to: resetToDay).day ?? 0
    }
    
    /// 指定された日付の日付部分と現在の時刻を組み合わたDateオブジェクトを返す
    public func combineDateWithCurrentTime(theDay: Date) -> Date {
        let now = Date()
        guard let newDate = c.date(
            bySettingHour: c.component(.hour, from: now),
            minute: c.component(.minute, from: now),
            second: c.component(.second, from: now),
            of: theDay
        ) else { return Date() }
        return newDate
    }
    
    /// 指定した日付の年月をタプルで取得
    public func getDateYearAndMonth(date: Date = DateFormatUtility.today) -> (year: Int, month: Int) {
        let today = convertDateComponents(date: date)
        guard let year = today.year,
              let month = today.month else { return (2024, 8) }
        return (year, month)
    }
    
    /// 指定した日付の年月をタプルで取得
    public func calcDate(date: Date, value: Int) -> Date {
        return c.date(byAdding: .day, value: value, to: date) ?? Date()
    }
}
