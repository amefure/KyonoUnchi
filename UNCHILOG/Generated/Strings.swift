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
  /// キャンセル
  internal static let dialogButtonCancel = L10n.tr("Localizable", "dialog_button_cancel", fallback: "キャンセル")
  /// OK
  internal static let dialogButtonOk = L10n.tr("Localizable", "dialog_button_ok", fallback: "OK")
  /// うんちの記録を本当に削除しますか？
  internal static let dialogDeletePoop = L10n.tr("Localizable", "dialog_delete_poop", fallback: "うんちの記録を本当に削除しますか？")
  /// うんちの記録を本当に削除しますか？
  /// 削除するとリンクも全てなくなります。
  internal static let dialogDeleteTheday = L10n.tr("Localizable", "dialog_delete_theday", fallback: "うんちの記録を本当に削除しますか？\n削除するとリンクも全てなくなります。")
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
  /// うんちの記録を
  /// 更新しました。
  internal static let dialogUpdatePoop = L10n.tr("Localizable", "dialog_update_poop", fallback: "うんちの記録を\n更新しました。")
  /// ・アプリにパスワードを設定してロックをかけることができます。
  internal static let settingSectionAppDesc = L10n.tr("Localizable", "setting_section_app_desc", fallback: "・アプリにパスワードを設定してロックをかけることができます。")
  /// アプリをロックする
  internal static let settingSectionAppLock = L10n.tr("Localizable", "setting_section_app_lock", fallback: "アプリをロックする")
  /// 週始まり
  internal static let settingSectionCalendarInitWeek = L10n.tr("Localizable", "setting_section_calendar_init_week", fallback: "週始まり")
  /// カレンダー設定
  internal static let settingSectionCalendarTitle = L10n.tr("Localizable", "setting_section_calendar_title", fallback: "カレンダー設定")
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
