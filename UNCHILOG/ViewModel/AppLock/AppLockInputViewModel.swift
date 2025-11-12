//
//  AppLockInputViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import UIKit

@Observable
final class AppLockInputState {
    /// アプリメイン画面遷移
    var entryFlag: Bool = false
}

final class AppLockInputViewModel {
    var state = AppLockInputState()

    /// `Repository`
    private let keyChainRepository: KeyChainRepository

    init(keyChainRepository: KeyChainRepository) {
        self.keyChainRepository = keyChainRepository
    }

    public func entryPassword(password: [String]) {
        state.entryFlag = true
        let pass = password.joined(separator: "")
        keyChainRepository.entry(value: pass)
    }
}

