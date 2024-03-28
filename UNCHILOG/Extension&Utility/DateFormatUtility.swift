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

    init(format: String = "yyyy-MM-dd") {
        df.dateFormat = format
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = c
    }
    
    /// JP：yyyy年M月d日  String
    public func getString(date: Date) -> String {
        return df.string(from: date)
    }
    
    /// JP：yyyy年M月d日 Date
    public func getDate(str: String) -> Date {
        return df.date(from: str) ?? Date()
    }

}

extension DateFormatUtility {
    
    public func convertDateComponents(date: Date) -> DateComponents {
        c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
    
    // 指定された日付の日付部分と現在の時刻を組み合わたDateオブジェクトを返す
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