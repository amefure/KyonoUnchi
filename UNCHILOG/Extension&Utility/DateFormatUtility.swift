//
//  DateFormatUtility.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit

class DateFormatUtility {
    
    private let df = DateFormatter()
    private let c = Calendar(identifier: .gregorian)
    
    static let today: Date = Date()
    
    init(format: String = "yyyy-MM-dd") {
        df.dateFormat = format
        df.locale = Locale(identifier: "ja_JP")
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
    
    /// 受け取った日付が今日と同じかどうか
    public func checkInSameDayAs(date: Date) -> Bool {
        c.isDate(date, inSameDayAs: DateFormatUtility.today)
    }
    
    /// 受け取った日付が今日とどれだけ離れているか
    public func daysDifferenceFromToday(date: Date) -> Int {
        c.dateComponents([.day], from: date, to: DateFormatUtility.today).day ?? 0
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
}
