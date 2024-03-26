//
//  DateFormatManager.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit

class DateFormatManager {

    private let df = DateFormatter()

    init(format: String = "yyyy-MM-dd") {
        df.dateFormat = format
        df.locale = Locale(identifier: "ja_JP")
        df.calendar = Calendar(identifier: .gregorian)
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
