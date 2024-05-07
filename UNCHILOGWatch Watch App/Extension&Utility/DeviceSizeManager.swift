//
//  DeviceSizeManager.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/03.
//

import WatchKit


class DeviceSizeManager {
    static var deviceWidth: CGFloat {
        WKInterfaceDevice.current().screenBounds.size.width
    }

    static var deviceHeight: CGFloat {
        WKInterfaceDevice.current().screenBounds.size.height
    }
}

