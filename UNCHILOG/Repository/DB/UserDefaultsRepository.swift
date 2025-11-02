//
//  UserDefaultsRepository.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit

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
