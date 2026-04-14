//
//  AdMobView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/20.
//

import Foundation
@preconcurrency
import GoogleMobileAds
import SwiftUI
import UIKit


struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context _: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner) // インスタンスを生成
        // 諸々の設定をしていく
        banner.adUnitID = AdMobAdsKey.bannerCode // 自身の広告IDに置き換える
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.rootViewController = windowScene?.windows.first!.rootViewController
        let request = Request()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.load(request)
        return banner // 最終的にインスタンスを返す
    }

    func updateUIView(_: BannerView, context _: Context) {
        // 特にないのでメソッドだけ用意
    }
}


protocol InterstitialServiceProtocol {
    @MainActor
    func showOrCountInterstitial() async
}


final class InterstitialState: @unchecked Sendable {
    fileprivate(set) var interstitialAd: InterstitialAd?
    private(set) var count: Int = 0
    
    fileprivate func increment() { count += 1 }
    
    fileprivate func updateCount(_ currentvalue: Int) {
        count = currentvalue
    }
    
    /// インタースティシャル広告を表示するかどうか(カウントを満たしたかどうか)
    fileprivate func isShowStatus() -> Bool {
        count >= AdsConfig.COUNT_INTERSTITIAL
    }
}

final class InterstitialService: NSObject, Sendable, InterstitialServiceProtocol, FullScreenContentDelegate {
    
    private let state = InterstitialState()
    
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        super.init()
        // ローカル保存されているカウントを取得
        getCount()
        // イニシャライザのタイミングで広告をロードしておく
        Task { [weak self] in
            await self?.loadAds()
        }
    }

    
    @MainActor
    func showOrCountInterstitial() async {
        // インタースティシャル広告カウント追加
        addCount()
        
        // カウントアップして表示条件を満たしたかどうか
        guard state.isShowStatus() else { return }
        
        // 広告が未読み込みであれば読み込んでから1度だけ再度表示を試みる
        AppLogger.logger.debug("インタースティシャルCHECK：\(self.state.interstitialAd)")
        guard let ad = state.interstitialAd else {
            await loadAds()
            if let ad = state.interstitialAd {
                showAd(ad)
            }
            return
        }
        showAd(ad)
        // カウントリセット
        resetCount()
    }
    
    @MainActor
    private func showAd(_ ad: InterstitialAd) {
        AppLogger.logger.debug("インタースティシャルshowAd")
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootVC = windowScene?.windows.first?.rootViewController else { return }
        AppLogger.logger.debug("インタースティシャル再生")
        ad.present(from: rootVC)
    }
    
    ///  広告をロード
    @MainActor
    private func loadAds() async {
        do {
            let request = Request()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let ad = try await InterstitialAd.load(with: AdMobAdsKey.interstitialCode, request: request)
            ad.fullScreenContentDelegate = self
            state.interstitialAd = ad
            AppLogger.logger.debug("インタースティシャル広告ロード成功")
        } catch {
            // 広告読み込み失敗
            AppLogger.logger.debug("インタースティシャル広告ロード失敗：\(error)")
        }
    }
    
    /// カウントアップ
    public func addCount() {
        state.increment()
        userDefaultsRepository.setCountInterstitial(state.count)
        AppLogger.logger.debug("インタースティシャルカウント：\(self.state.count)")
    }
    /// カウントリセット
    private func resetCount() {
        state.updateCount(0)
        userDefaultsRepository.setCountInterstitial(0)
    }
    
    /// カウント取得
    private func getCount() {
        let currentValue = userDefaultsRepository.getCountInterstitial()
        state.updateCount(currentValue)
    }

}

