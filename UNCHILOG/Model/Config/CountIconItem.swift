//
//  CountIconItem.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/20.
//

/// カレンダー日付に表示されるカウントアイコン
enum CountIconItem: Int, CaseIterable {
    case simple = 0
    case simpleDark = 1
    case simpleBlack = 2
    case poop = 3
    
    var name: String {
        switch self {
        case .simple:
            "シンプル(デフォルト)"
        case .simpleDark:
            "シンプルダークブラウン"
        case .simpleBlack:
            "シンプルブラック"
        case .poop:
            "うんち"
        }
    }
}
