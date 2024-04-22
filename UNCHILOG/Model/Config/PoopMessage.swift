//
//  PoopMessage.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/21.
//

import UIKit

enum PoopMessage: CaseIterable {
    
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case eleven
    case twelve
    
    public func name(difference: Int) -> String {
        return switch self {
        case .one:
            L10n.poopMessage1
        case .two:
            L10n.poopMessage2
        case .three:
            L10n.poopMessage3
        case .four:
            L10n.poopMessage4
        case .five:
            L10n.poopMessage5
        case .six:
            if difference != 0 {
                L10n.poopMessage6(difference)
            } else {
                L10n.poopMessage1
            }
        case .seven:
            L10n.poopMessage7
        case .eight:
            L10n.poopMessage8
        case .nine:
            L10n.poopMessage9
        case .ten:
            L10n.poopMessage10
        case .eleven:
            L10n.poopMessage11
        case .twelve:
            L10n.poopMessage12
        }
    }
    static func random() -> PoopMessage {
        let allCases = self.allCases
        let randomIndex = Int(arc4random_uniform(UInt32(allCases.count)))
        return allCases[safe: randomIndex] ?? .one
    }
}
