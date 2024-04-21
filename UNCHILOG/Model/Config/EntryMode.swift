//
//  EntryMode.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/05.
//

import UIKit

// うんち登録モード
enum EntryMode: Int {
    case simple = 1
    case detail = 2
    
    var name: String {
        switch self {
        case .simple:
            return "シンプル"
        case .detail:
            return "詳細"
        }
    }
}
