//
//  SettingViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import UIKit
import Combine

@Observable
final class SettingState {
    var isShowPassInput: Bool = false
    var isShowInAppPurchaseView: Bool = false
}


final class SettingViewModel: ObservableObject {
    
    var state = SettingState()
    
    @Published var isLock: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []

    private let keyChainRepository: KeyChainRepository

    init(
        keyChainRepository: KeyChainRepository
    ) {
        self.keyChainRepository = keyChainRepository
    }

    func onAppear() {
        setUpIsLock()
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    /// アプリロック
    private func setUpIsLock() {
        isLock = keyChainRepository.getData().count == 4
        
        $isLock
            .eraseToAnyPublisher()
            .dropFirst() // 初回はスキップ
            .removeDuplicates() // 重複値は流さない
            .sink { [weak self] flag in
                guard let self else { return }
                if flag {
                    // パスワード入力画面を表示
                    state.isShowPassInput = true
                } else {
                    // アプリパスワードをリセット
                    keyChainRepository.delete()
                }
            }.store(in: &cancellables)
    }
    
    /// アプリシェアロジック
    @MainActor
    public func shareApp(shareText: String, shareLink: String) {
        ShareInfoUtillity.shareApp(shareText: shareText, shareLink: shareLink)
    }
}

