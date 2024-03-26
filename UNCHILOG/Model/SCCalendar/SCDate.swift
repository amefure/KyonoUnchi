//
//  SCDate.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import UIKit

struct SCDate: Identifiable {
    public var id: UUID = UUID()
    public var year: Int
    public var month: Int
    public var day: Int
    public var week: SCWeek?
    public var holidayName: String = ""
    
    public func getDate() -> String {
        "\(year)-\(month)-\(day)"
    }
}
