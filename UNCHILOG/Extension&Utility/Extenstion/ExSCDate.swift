//
//  ExSCDate.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import UIKit
import SCCalendar

extension SCDate {
    /// 年月日取得
    public func getDate(format: String = "yyyy-M-d") -> String {
        let str = DateFormatUtility(format: format).getString(date: date ?? Date())
        return str
    }
}

