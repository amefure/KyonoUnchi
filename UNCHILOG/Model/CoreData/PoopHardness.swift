//
//  PoopHardness.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

enum PoopHardness: Int, CaseIterable {
    case undefined = 0
    case soft = 1
    case semisoft = 2
    case medium = 3
    case semihard = 4
    case hard = 5
    
    public var name: String {
        return switch self {
        case .undefined:
            "none"
        case .soft:
            "柔らかめ"
        case .semisoft:
            "やや柔らかめ"
        case .medium:
            "中くらい"
        case .semihard:
            "やや硬め"
        case .hard:
            "硬め"
        }
    }
}
