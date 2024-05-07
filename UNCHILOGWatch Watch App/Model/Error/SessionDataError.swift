//
//  SessionDataError.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import UIKit

// Watch ↔︎ iOS 間データ送受信エラークラス
enum SessionDataError: WatchError {
    /// ES001：JSON変換エラー
    case jsonConversionFailed
    
    /// EC002：送信エラー
    case sendFailed
    
    /// ES003：受信エラー(辞書Keyが存在しない)
    case notExistHeader
    
    /// ES004：不明
    case unidentified
    
    public var title: String { L10n.sessionErrorTitle }
    
    var message: String {
        return switch self {
        case .jsonConversionFailed:
            L10n.sessionErrorJsonFailedMessage
        case .sendFailed:
            L10n.sessionErrorSendFailedMessage
        case .notExistHeader:
            L10n.sessionErrorNotExistHeaderMessage
        case .unidentified:
            L10n.sessionErrorUnidentifiedMessage
        }
    }
}
