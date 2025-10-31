//
//  ShareInfoUtillity.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//

import UIKit

final class ShareInfoUtillity: Sendable {
    /// アプリシェアロジック
    @MainActor
    static func shareApp(shareText: String, shareLink: String) {
        guard let url = URL(string: shareLink) else { return }
        let items = [shareText, url] as [Any]
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
