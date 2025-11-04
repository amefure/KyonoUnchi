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
}

final class RootViewModel {
    
    static let shared = RootViewModel()
    
    var state = RootViewState()
    
    private let interstitialService: InterstitialServiceProtocol
    
    private let localRepository: PoopRepository
    
    init(
        repositoryDependency: RepositoryDependency = RepositoryDependency()
    ) {
        localRepository = repositoryDependency.poopRepository
        interstitialService = InterstitialService(userDefaultsRepository: repositoryDependency.userDefaultsRepository)
    }
    
    func onAppear() {
        
    }
}

extension RootViewModel {
    
    public func addSimplePoop() {
        localRepository.addPoop(createdAt: Date())
    }
    
    public func showOrCountInterstitial() {
        Task {
            await interstitialService.showOrCountInterstitial()
        }
    }
}
