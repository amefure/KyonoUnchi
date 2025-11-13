//
//  RootViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/01.
//

import GoogleMobileAds


@Observable
final class RootViewState {
    /// 詳細登録画面表示
    var isShowInputDetailPoop: Bool = false
    /// 設定画面表示
    var isShowSetting: Bool = false
    /// グラフ画面表示
    var isShowChart: Bool = false
    /// 登録成功アラート表示
    var isShowSuccessEntryAlert: Bool = false
    /// アップデートダイアログ表示
    var isUpdateNotifyDialog: Bool = false
}

final class RootViewModel {
    
    var state = RootViewState()
    
    private let localRepository: WrapLocalRepositoryProtocol
    private let userDefaultsRepository: UserDefaultsRepository
    private let interstitialService: InterstitialServiceProtocol
    
    init(
        localRepository: WrapLocalRepositoryProtocol,
        userDefaultsRepository: UserDefaultsRepository,
        interstitialService: InterstitialServiceProtocol
    ) {
        self.localRepository = localRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.interstitialService = interstitialService
    }
    
    func onAppear() {
        showDialog()
    }
}

extension RootViewModel {
    
    private func showDialog() {
        let flag = userDefaultsRepository.getIsShowNotifyDialog()
        // 既存ユーザーのみに見せたいのでデータが存在するかつ表示フラグがfalseの場合のみ
        if !localRepository.fetchAllPoops().isEmpty && !flag {
            state.isUpdateNotifyDialog = true
        }
        userDefaultsRepository.setIsShowNotifyDialog(true)
    }
    
    public func addSimplePoop() {
        let added = localRepository.addPoopSimple(createdAt: Date())
        // カレンダーを更新
        NotificationCenter.default.post(name: .updateCalendar, object: added)
    }
    
    @MainActor
    public func showOrCountInterstitial() {
        let flag = userDefaultsRepository.getPurchasedRemoveAds()
        // 課金済みなら広告を表示しない
        guard !flag else { return }
        Task {
            await interstitialService.showOrCountInterstitial()
        }
    }
}
