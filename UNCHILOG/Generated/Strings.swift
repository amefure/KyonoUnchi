// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Face IDでログインする
  internal static let appLockFaceId = L10n.tr("Localizable", "app_lock_face_id", fallback: "Face IDでログインする")
  /// パスワードが違います。
  internal static let appLockFailedPassword = L10n.tr("Localizable", "app_lock_failed_password", fallback: "パスワードが違います。")
  /// 登録
  internal static let appLockInputEntryButton = L10n.tr("Localizable", "app_lock_input_entry_button", fallback: "登録")
  /// パスワード登録
  internal static let appLockInputTitle = L10n.tr("Localizable", "app_lock_input_title", fallback: "パスワード登録")
  /// Touch IDでログインする
  internal static let appLockTouchId = L10n.tr("Localizable", "app_lock_touch_id", fallback: "Touch IDでログインする")
  /// iPhoneとApple Watchの同期に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。
  internal static let connectErrorActivateFailedMessage = L10n.tr("Localizable", "connect_error_activate_failed_message", fallback: "iPhoneとApple Watchの同期に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。")
  /// iPhoneとApple Watchの接続に失敗しました。Bletoothのペアリング状況を確認してください。
  internal static let connectErrorConnectFailedMessage = L10n.tr("Localizable", "connect_error_connect_failed_message", fallback: "iPhoneとApple Watchの接続に失敗しました。Bletoothのペアリング状況を確認してください。")
  /// 通信エラー
  internal static let connectErrorTitle = L10n.tr("Localizable", "connect_error_title", fallback: "通信エラー")
  /// キャンセル
  internal static let dialogButtonCancel = L10n.tr("Localizable", "dialog_button_cancel", fallback: "キャンセル")
  /// OK
  internal static let dialogButtonOk = L10n.tr("Localizable", "dialog_button_ok", fallback: "OK")
  /// うんちの記録を本当に削除しますか？
  internal static let dialogDeletePoop = L10n.tr("Localizable", "dialog_delete_poop", fallback: "うんちの記録を本当に削除しますか？")
  /// うんちの記録を本当に削除しますか？
  /// 削除するとリンクも全てなくなります。
  internal static let dialogDeleteTheday = L10n.tr("Localizable", "dialog_delete_theday", fallback: "うんちの記録を本当に削除しますか？\n削除するとリンクも全てなくなります。")
  /// うんちの登録に失敗しました。
  internal static let dialogEntryFailed = L10n.tr("Localizable", "dialog_entry_failed", fallback: "うんちの登録に失敗しました。")
  /// 時間を置いてから再度試してください。
  internal static let dialogEntryFailedMessage = L10n.tr("Localizable", "dialog_entry_failed_message", fallback: "時間を置いてから再度試してください。")
  /// うんちの記録を
  /// 登録しました。
  internal static let dialogEntryPoop = L10n.tr("Localizable", "dialog_entry_poop", fallback: "うんちの記録を\n登録しました。")
  /// カレンダーの表示範囲外です。
  internal static let dialogOutOfRangeCalendar = L10n.tr("Localizable", "dialog_out_of_range_calendar", fallback: "カレンダーの表示範囲外です。")
  /// Localizable.strings
  ///   UNCHILOG
  /// 
  ///   Created by t&a on 2024/03/24.
  internal static let dialogTitle = L10n.tr("Localizable", "dialog_title", fallback: "お知らせ")
  /// 「%@」モードに
  /// 変更しました。
  internal static func dialogUpdateEntryMode(_ p1: Any) -> String {
    return L10n.tr("Localizable", "dialog_update_entry_mode_%@", String(describing: p1), fallback: "「%@」モードに\n変更しました。")
  }
  /// 週始まりを「%@」に
  /// 変更しました。
  internal static func dialogUpdateInitWeek(_ p1: Any) -> String {
    return L10n.tr("Localizable", "dialog_update_init_week_%@", String(describing: p1), fallback: "週始まりを「%@」に\n変更しました。")
  }
  /// うんちの記録を
  /// 更新しました。
  internal static let dialogUpdatePoop = L10n.tr("Localizable", "dialog_update_poop", fallback: "うんちの記録を\n更新しました。")
  /// 順調♪順調♪
  internal static let poopMessage1 = L10n.tr("Localizable", "poop_message_1", fallback: "順調♪順調♪")
  /// 自分のうんちを把握するのは大事だよ
  internal static let poopMessage10 = L10n.tr("Localizable", "poop_message_10", fallback: "自分のうんちを把握するのは大事だよ")
  /// 今日のあなたは大吉だよ
  internal static let poopMessage11 = L10n.tr("Localizable", "poop_message_11", fallback: "今日のあなたは大吉だよ")
  /// お腹を冷やさないようにね
  internal static let poopMessage12 = L10n.tr("Localizable", "poop_message_12", fallback: "お腹を冷やさないようにね")
  /// バナナうんちは良いうんち！
  internal static let poopMessage2 = L10n.tr("Localizable", "poop_message_2", fallback: "バナナうんちは良いうんち！")
  /// ぷりっ♪
  internal static let poopMessage3 = L10n.tr("Localizable", "poop_message_3", fallback: "ぷりっ♪")
  /// 健康うんちは75％が水分なんだって
  internal static let poopMessage4 = L10n.tr("Localizable", "poop_message_4", fallback: "健康うんちは75％が水分なんだって")
  /// 1日に150~250g出すのがベスト！
  internal static let poopMessage5 = L10n.tr("Localizable", "poop_message_5", fallback: "1日に150~250g出すのがベスト！")
  /// うんちが%@日出てないよ！
  internal static func poopMessage6(_ p1: Any) -> String {
    return L10n.tr("Localizable", "poop_message_6_%@", String(describing: p1), fallback: "うんちが%@日出てないよ！")
  }
  /// 今日は何回でた？
  internal static let poopMessage7 = L10n.tr("Localizable", "poop_message_7", fallback: "今日は何回でた？")
  /// 今日も良い1日になりますように
  internal static let poopMessage8 = L10n.tr("Localizable", "poop_message_8", fallback: "今日も良い1日になりますように")
  /// 記録を続けていてすごい！
  internal static let poopMessage9 = L10n.tr("Localizable", "poop_message_9", fallback: "記録を続けていてすごい！")
  /// データの不整合エラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。
  internal static let sessionErrorJsonFailedMessage = L10n.tr("Localizable", "session_error_json_failed_message", fallback: "データの不整合エラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。")
  /// データの受信に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。
  internal static let sessionErrorNotExistHeaderMessage = L10n.tr("Localizable", "session_error_not_exist_header_message", fallback: "データの受信に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。")
  /// データの送信に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。
  internal static let sessionErrorSendFailedMessage = L10n.tr("Localizable", "session_error_send_failed_message", fallback: "データの送信に失敗しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。")
  /// セッションエラー
  internal static let sessionErrorTitle = L10n.tr("Localizable", "session_error_title", fallback: "セッションエラー")
  /// 予期せぬエラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。
  internal static let sessionErrorUnidentifiedMessage = L10n.tr("Localizable", "session_error_unidentified_message", fallback: "予期せぬエラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。")
  /// ・アプリにパスワードを設定してロックをかけることができます。
  internal static let settingSectionAppDesc = L10n.tr("Localizable", "setting_section_app_desc", fallback: "・アプリにパスワードを設定してロックをかけることができます。")
  /// うんちの登録モードを切り替え
  internal static let settingSectionAppEntryMode = L10n.tr("Localizable", "setting_section_app_entry_mode", fallback: "うんちの登録モードを切り替え")
  /// アプリをロックする
  internal static let settingSectionAppLock = L10n.tr("Localizable", "setting_section_app_lock", fallback: "アプリをロックする")
  /// アプリ設定
  internal static let settingSectionAppTitle = L10n.tr("Localizable", "setting_section_app_title", fallback: "アプリ設定")
  /// 週始まり
  internal static let settingSectionCalendarInitWeek = L10n.tr("Localizable", "setting_section_calendar_init_week", fallback: "週始まり")
  /// カレンダー設定
  internal static let settingSectionCalendarTitle = L10n.tr("Localizable", "setting_section_calendar_title", fallback: "カレンダー設定")
  /// アプリの不具合はこちら
  internal static let settingSectionLinkContact = L10n.tr("Localizable", "setting_section_link_contact", fallback: "アプリの不具合はこちら")
  /// ・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。
  internal static let settingSectionLinkDesc = L10n.tr("Localizable", "setting_section_link_desc", fallback: "・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。")
  /// 「今日のうんち」をオススメする
  internal static let settingSectionLinkRecommend = L10n.tr("Localizable", "setting_section_link_recommend", fallback: "「今日のうんち」をオススメする")
  /// アプリをレビューする
  internal static let settingSectionLinkReview = L10n.tr("Localizable", "setting_section_link_review", fallback: "アプリをレビューする")
  /// 利用規約とプライバシーポリシー
  internal static let settingSectionLinkTerms = L10n.tr("Localizable", "setting_section_link_terms", fallback: "利用規約とプライバシーポリシー")
  /// 1週間のうんち記録
  internal static let watchWeekTitle = L10n.tr("Localizable", "watch_week_title", fallback: "1週間のうんち記録")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
