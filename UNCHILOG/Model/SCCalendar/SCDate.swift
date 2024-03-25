//
//  SCDate.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import UIKit

struct SCDate: Identifiable {
    public var id: UUID = UUID()
    public var date: Int
    public var week: SCWeek
    public var holidayName: String
}
