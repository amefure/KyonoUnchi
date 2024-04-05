//
//  PoopVolume.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

enum PoopVolume: Int, CaseIterable {
    case undefined = 0
    case small = 1
    case semismall = 2
    case medium = 3
    case semilarge = 4
    case large = 5
    
    public var name: String {
        return switch self {
        case .undefined:
            "none"
        case .small:
            "少なめ"
        case .semismall:
            "やや少なめ"
        case .medium:
            "中くらい"
        case .semilarge:
            "やや多め"
        case .large:
            "多め"
        }
    }
}
