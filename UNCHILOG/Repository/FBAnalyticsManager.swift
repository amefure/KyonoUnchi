//
//  FBAnalyticsManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/05/03.
//

import FirebaseAnalytics

final class FBAnalyticsManager: Sendable {
    /// `screen_view`イベント計測
    /// デフォルトイベント：`AnalyticsEventScreenView`
    static func loggingScreen(screen: AppSreenClassName) {
        #if !DEBUG
            Analytics.logEvent(
                AnalyticsEventScreenView,
                parameters: [
                    AnalyticsParameterScreenName: screen.name(),
                    AnalyticsParameterScreenClass: screen.rawValue,
                ]
            )
        #endif
    }
}

/// 　`screen_view`イベント計測用型
enum AppSreenClassName: String {
    case AppLockScreen
    case InAppPurchaseScreen
    case SelectEntryModeScreen

    func name() -> String {
        switch self {
        case .AppLockScreen:
            "アプリロック画面"
        case .InAppPurchaseScreen:
            "アプリ内課金購入画面"
        case .SelectEntryModeScreen:
            "登録モード変更画面"
        }
    }
}
