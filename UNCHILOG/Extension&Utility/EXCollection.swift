//
//  EXCollection.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import UIKit

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

