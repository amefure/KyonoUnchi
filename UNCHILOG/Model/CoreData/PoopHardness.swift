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
    case medium = 2
    case hard = 3
    
    public var image: Image {
        return switch self {
        case .undefined:
            Image(systemName: "swift")
        case .soft:
            Image(systemName: "swift")
        case .medium:
            Image(systemName: "swift")
        case .hard:
            Image(systemName: "swift")
        }
    }
}
