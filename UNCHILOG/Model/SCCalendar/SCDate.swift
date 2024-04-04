//
//  SCDate.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import SwiftUI

struct SCDate: Identifiable {
    public var id: UUID = UUID()
    public var year: Int
    public var month: Int
    public var day: Int
    public var date: Date?
    public var week: SCWeek?
    public var holidayName: String = ""
    
    /// 年月日取得
    public func getDate(format: String = "yyyy-M-d") -> String {
        let str = DateFormatUtility(format: format).getString(date: date ?? Date())
        return str
    }
    
    public func dayColor(defaultColor: Color = .gray) -> Color {
        guard let week = week else { return defaultColor }
        if !holidayName.isEmpty { return .red }
        if week == .saturday {
            return .blue
        } else if week == .sunday {
            return .red
        } else {
            return defaultColor
        }
    }
}

extension SCDate {
    static let demo: SCDate = SCDate(year: 2024, month: 12, day: 25)
}
