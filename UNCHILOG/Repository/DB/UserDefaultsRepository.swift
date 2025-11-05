//
//  UserDefaultsRepository.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit
import SCCalendar

/// `UserDefaults`の基底クラス
/// スレッドセーフにするため `final class` + `Sendable`準拠
/// `UserDefaults`が`Sendable`ではないがスレッドセーフのため`@unchecked`で無視しておく
final class UserDefaultsRepository: @unchecked Sendable {
    /// `UserDefaults`がスレッドセーフではあるが`Sendable`ではないため`@unchecked`で回避
    private let userDefaults = UserDefaults.standard

    /// Bool：保存
    private func setBoolData(key: String, isOn: Bool) {
        userDefaults.set(isOn, forKey: key)
    }

    /// Bool：取得
    private func getBoolData(key: String) -> Bool {
        userDefaults.bool(forKey: key)
    }

    /// Int：保存
    private func setIntData(key: String, value: Int) {
        userDefaults.set(value, forKey: key)
    }

    /// Int：取得
    private func getIntData(key: String) -> Int {
        userDefaults.integer(forKey: key)
    }

    /// String：保存
    private func setStringData(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }

    /// String：取得
    private func getStringData(key: String, initialValue: String = "") -> String {
        userDefaults.string(forKey: key) ?? initialValue
    }
}

extension UserDefaultsRepository {
    /// 登録：インタースティシャルリセット
    func setCountInterstitial(_ value: Int) {
        setIntData(key: UserDefaultsKey.COUNT_INTERSTITIAL, value: value)
    }
    
    /// 取得：インタースティシャル取得
    func getCountInterstitial() -> Int {
        getIntData(key: UserDefaultsKey.COUNT_INTERSTITIAL)
    }
    
    /// 取得：週始まり
    func getInitWeek() -> SCWeek {
        let week = getIntData(key: UserDefaultsKey.INIT_WEEK)
        return SCWeek(rawValue: week) ?? SCWeek.sunday
    }

    /// 登録：週始まり
    func setInitWeek(_ week: SCWeek) {
        setIntData(key: UserDefaultsKey.INIT_WEEK, value: week.rawValue)
    }
    
    /// 取得：登録モード
    func getEntryMode() -> EntryMode {
        let mode = getIntData(key: UserDefaultsKey.ENTRY_MODE)
        return EntryMode(rawValue: mode) ?? EntryMode.detail
    }

    /// 登録：登録モード
    func setEntryMode(_ mode: EntryMode) {
        setIntData(key: UserDefaultsKey.ENTRY_MODE, value: mode.rawValue)
    }
    
    /// 取得：アプリアイコン
    func getAppIcon() -> String {
        getStringData(key: UserDefaultsKey.APP_ICON_NAME, initialValue: "AppIcon")
    }

    /// 登録：アプリアイコン
    func setAppIcon(_ iconName: String) {
        setStringData(key: UserDefaultsKey.APP_ICON_NAME, value: iconName)
    }
}
