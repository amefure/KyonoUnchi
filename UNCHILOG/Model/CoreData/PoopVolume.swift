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
    case medium = 2
    case large = 3
    
    public var image: Image {
        return switch self {
        case .undefined:
            Image(systemName: "swift")
        case .small:
            Image(systemName: "swift")
        case .medium:
            Image(systemName: "swift")
        case .large:
            Image(systemName: "swift")
        }
    }
}
