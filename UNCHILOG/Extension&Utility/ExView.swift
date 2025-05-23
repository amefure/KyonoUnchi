//
//  ExView.swift
//  UNCHILOG
//
//  Created by t&a on 2025/05/23.
//

import SwiftUI

extension View {
    /// モディファイアをif文で分岐して有効/無効を切り替えることができる拡張
    ///
    /// - Parameters:
    ///   - condition: 有効/無効の条件
    ///   - apply: 有効時に適応させたいモディファイア

    /// Example:
    /// ```
    /// .if(condition) { view in
    ///     view.foregroundStyle(.green)
    /// }
    /// ```
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}
