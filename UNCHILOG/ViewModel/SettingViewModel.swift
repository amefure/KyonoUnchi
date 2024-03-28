//
//  SettingViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import UIKit

/// SettingView画面全域を管理するViewModel
/// 配下のViewも含めて管理
class SettingViewModel: ObservableObject {
    @Published var isShowPassInput: Bool = false
    @Published private(set) var isLock: Bool = false

    private let keyChainRepository: KeyChainRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        
        checkAppLock()
    }

    // MARK: - App Lock
    /// アプリにロックがかけてあるかをチェック
    private func checkAppLock() {
        isLock = keyChainRepository.getData().count == 4
    }

    /// パスワード入力画面を表示
    public func showPassInput() {
        isShowPassInput = true
    }

    /// アプリロックパスワードをリセット
    public func deletePassword() {
        keyChainRepository.delete()
    }
    
    // MARK: - Share Logic

    /// アプリシェアロジック
    public func shareApp(shareText: String, shareLink: String) {
        let items = [shareText, URL(string: shareLink)!] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popPC = activityVC.popoverPresentationController {
                popPC.sourceView = activityVC.view
                popPC.barButtonItem = .none
                popPC.sourceRect = activityVC.accessibilityFrame
            }
        }
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        rootVC?.present(activityVC, animated: true, completion: {})
    }
}

