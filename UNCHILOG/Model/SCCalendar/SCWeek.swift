//
//  SCWeek.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import UIKit

enum SCWeek: Int, CaseIterable {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    
    public var fullSymbols: String {
        switch self {
        case .sunday: return "日曜日"
        case .monday: return "月曜日"
        case .tuesday: return "火曜日"
        case .wednesday: return "水曜日"
        case .thursday: return "木曜日"
        case .friday: return "金曜日"
        case .saturday: return "土曜日"
        }
    }
    
    public var shortSymbols: String {
        switch self {
        case .sunday: return "日"
        case .monday: return "月"
        case .tuesday: return "火"
        case .wednesday: return "水"
        case .thursday: return "木"
        case .friday: return "金"
        case .saturday: return "土"
        }
    }
}

extension Array where Element == SCWeek {
    mutating func moveWeekToFront(_ week: SCWeek) {
        guard let index = firstIndex(of: week) else { return }
        self = Array(self[index...] + self[..<index])
    }
}
