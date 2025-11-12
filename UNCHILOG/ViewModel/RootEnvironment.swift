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
    /// 登録モード
    fileprivate(set) var entryMode: EntryMode = .simple
    
    /// 詳細ページで表示するダイアログ
    var showSimpleEntryDetailDialog: Bool = false
}


final class RootEnvironment {
    
    var state = RootEnvironmentState()

    private let localRepository: WrapLocalRepositoryProtocol
    private let userDefaultsRepository: UserDefaultsRepository
    private let keyChainRepository: KeyChainRepository
    private let inAppPurchaseRepository: InAppPurchaseRepository
    private let watchConnectRepository: WatchConnectRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        localRepository: WrapLocalRepositoryProtocol,
        keyChainRepository: KeyChainRepository,
        userDefaultsRepository: UserDefaultsRepository,
        inAppPurchaseRepository: InAppPurchaseRepository,
        watchConnectRepository: WatchConnectRepository,
    ) {
        self.localRepository = localRepository
        self.keyChainRepository = keyChainRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.inAppPurchaseRepository = inAppPurchaseRepository
        self.watchConnectRepository = watchConnectRepository
        
        getEntryMode()
        getAppLock()
        getAppInPurchased()

        watchConnectRepository.entryDate
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self else { return }
                let added = self.localRepository.addPoopSimple(createdAt: date)
                NotificationCenter.default.post(name: .updateCalendar, object: added)
            }.store(in: &cancellables)
        
        watchConnectRepository.sendPoopDataFlag
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self else { return }
                self.sendWatchWeekPoops()
            }.store(in: &cancellables)
    
    }
    
    /// アプリ起動時に1回だけ呼ばれる設計
    @MainActor
    func onAppear() {
        // 購入済み課金アイテム観測
        inAppPurchaseRepository.purchasedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                // 購入済みアイテム配列が変化した際に購入済みかどうか確認
                let removeAds = inAppPurchaseRepository.isPurchased(ProductItem.removeAds.id)
                // 両者trueなら更新
                if removeAds { state.removeAds = true }
            }.store(in: &cancellables)   
    }
}

extension RootEnvironment {
    
    /// 課金アイテムの購入状況を確認
    @MainActor
    func listenInAppPurchase() {
        Task {
            // 課金アイテムの変化を観測
            await inAppPurchaseRepository.startListen()
        }
    }
    
    private func sendWatchWeekPoops() {
        if watchConnectRepository.isReachable() {
            let poops = localRepository.fetchAllPoops()
            let dateFormatUtility = DateFormatUtility(format: "yyyy年M月dd日")
            let endToday = dateFormatUtility.endOfDay(for: Date())
            let oneWeekAgo = dateFormatUtility.calcDate(date: endToday, value: -7)
            let weekPoops = poops.filter { poop in
                poop.date >= oneWeekAgo && poop.date <= endToday
            }
            watchConnectRepository.send(weekPoops)
        }
    }
}


// MARK: - UserDefaults
extension RootEnvironment {
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
    
    /// アプリ内課金
    private func getAppInPurchased() {
        state.removeAds = userDefaultsRepository.getPurchasedRemoveAds()
    }
}
