//
//  ConnectError.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import UIKit

// Watch ↔︎ iOS 間接続エラークラス
enum ConnectError: WatchError {
    /// EC001：コネクトエラー
    case connectFailed
    
    /// EC002：セッションアアクティベート失敗
    case activateFailed

    /// EC003：非サポート(これはエラーとして外部に公開しない)
    case noSupported

    public var title: String { L10n.connectErrorTitle }
    
    var message: String {
        return switch self {
        case .connectFailed:
            L10n.connectErrorConnectFailedMessage
        case .activateFailed:
            L10n.connectErrorActivateFailedMessage
        case .noSupported:
            ""
        }
    }
}
    
