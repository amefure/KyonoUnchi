//
//  RootViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/01.
//

import GoogleMobileAds

@MainActor
final class RootViewModel {
    private var interstitialAd: InterstitialAd?
    
    private let interstitialService: InterstitialServiceProtocol
    
    @MainActor
    init(interstitialService: InterstitialServiceProtocol = InterstitialService()) {
        self.interstitialService = interstitialService
    }
    
    
    func onAppear() {
        Task {
            await loadInterstitial()
        }
    }
    
    private func loadInterstitial() async {
        do {
            let ad = try await interstitialService.loadAds()
            interstitialAd = ad
        } catch {
            // 広告読み込み失敗
        }
    }
    
    func showInterstitial() async {
        // 広告が未読み込みであれば読み込んでから再度表示を試みる
        guard let ad = interstitialAd else {
            await loadInterstitial()
            await showInterstitial()
            return
        }
        interstitialService.showAds(ad)
    }
}

