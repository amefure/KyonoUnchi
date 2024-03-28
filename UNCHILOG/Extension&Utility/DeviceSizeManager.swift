//
//  DeviceSizeManager.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import UIKit

class DeviceSizeManager {
    static var deviceWidth: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        if DeviceSizeManager.isiPadSize {
            return window.screen.bounds.width / 1.4
        } else {
            return window.screen.bounds.width
        }
    }

    static var deviceHeight: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return window.screen.bounds.height
    }

    static var isSESize: Bool {
        if deviceWidth < 400 {
            return true
        } else {
            return false
        }
    }

    static var isiPadSize: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
}


