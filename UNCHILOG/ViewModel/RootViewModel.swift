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
    
    // シングルトン設計にしないと再生成が何度も発生しインタースティシャルが期待通りに動作しない
    static let shared = RootViewModel()
    
    var state = RootViewState()
    
    private let interstitialService: InterstitialServiceProtocol
    private let localRepository: WrapLocalRepositoryProtocol
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(
        repositoryDependency: RepositoryDependency = RepositoryDependency()
    ) {
        localRepository = repositoryDependency.poopRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        interstitialService = InterstitialService(userDefaultsRepository: repositoryDependency.userDefaultsRepository)
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
    
    public func showOrCountInterstitial() {
        Task {
            await interstitialService.showOrCountInterstitial()
        }
    }
}
