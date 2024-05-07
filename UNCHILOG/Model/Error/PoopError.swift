//
//  PoopError.swift
//  UNCHILOG
//
//  Created by t&a on 2024/05/07.
//

import UIKit

// Poopエラーの基底プロトコル
protocol PoopError: Error {
    var title: String { get }
    var message: String { get }
}
