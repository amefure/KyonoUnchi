//
//  RootEnvironment.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/27.
//

import UIKit
import Combine
import SCCalendar
import SwiftUI

private struct RootEnvironmentKey: @MainActor EnvironmentKey {
    @MainActor
    static let defaultValue = DIContainer.shared.resolve(RootEnvironment.self)
}

extension EnvironmentValues {
    @MainActor
    var rootEnvironment: RootEnvironment {
        get { self[RootEnvironmentKey.self] }
        set { self[RootEnvironmentKey.self] = newValue }
    }
}

@Observable
final class RootEnvironmentState {
    /// アプリロック
    fileprivate(set) var appLocked: Bool = false
    /// 広告削除購入フラグ
    fileprivate(set) var removeAds: Bool = false
    /// 容量解放購入フラグ
    fileprivate(set) var unlockStorage: Bool = false
    /// 週始まり
    fileprivate(set) var initWeek: SCWeek = .sunday
    /// 登録モード
    fileprivate(set) var entryMode: EntryMode = .simple
    
    /// 詳細ページで表示するダイアログ
    var showSimpleEntryDetailDialog: Bool = false
}


final class RootEnvironment {
    
    var state = RootEnvironmentState()

    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let localRepository: WrapLocalRepositoryProtocol
    private let watchConnectRepository: WatchConnectRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        localRepository: WrapLocalRepositoryProtocol,
        keyChainRepository: KeyChainRepository,
        userDefaultsRepository: UserDefaultsRepository,
        watchConnectRepository: WatchConnectRepository
    ) {
        self.localRepository = localRepository
        self.keyChainRepository = keyChainRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.watchConnectRepository = watchConnectRepository
        
        getInitWeek()
        getEntryMode()
        getAppLock()

        watchConnectRepository.entryDate
            .sink { [weak self] date in
                guard let self else { return }
                self.localRepository.addPoopSimple(createdAt: date)
            }.store(in: &cancellables)
    }
}


// MARK: - UserDefaults
extension RootEnvironment {

    
    /// 週始まりを取得
    private func getInitWeek() {
        state.initWeek = userDefaultsRepository.getInitWeek()
    }

    /// 週始まりを登録
    public func saveInitWeek(week: SCWeek) {
        state.initWeek = week
        userDefaultsRepository.setInitWeek(week)
    }
    
    /// 登録モード取得
    private func getEntryMode() {
        state.entryMode = userDefaultsRepository.getEntryMode()
    }

    /// 登録モード登録
    public func saveEntryMode(mode: EntryMode) {
        state.entryMode = mode
        userDefaultsRepository.setEntryMode(mode)
    }
    
    /// アプリアイコン取得
    public func getAppIcon() -> String {
        userDefaultsRepository.getAppIcon()
    }

    /// アプリアイコン登録
    public func saveAppIcon(iconName: String) {
        userDefaultsRepository.setAppIcon(iconName)
    }
    
    /// アプリにロックがかけてあるかをチェック
    private func getAppLock() {
        state.appLocked = keyChainRepository.getData().count == 4
    }
}
