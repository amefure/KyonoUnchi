//
//  PoopShape.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

enum PoopShape: Int, CaseIterable {
    case undefined = 0
    case korokoro = 1
    case semiKorokoro = 2
    case normal = 3
    case semiLiquid = 4
    case liquid = 5
    
    public var image: Image {
        return switch self {
        case .undefined:
            Image(systemName: "swift")
        case .korokoro:
            Image("poop_shape1")
        case .semiKorokoro:
            Image("poop_shape2")
        case .normal:
            Image("poop_shape3")
        case .semiLiquid:
            Image("poop_shape4")
        case .liquid:
            Image("poop_shape5")
        }
    }
}
