//
//  WatchLogger.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import UIKit

class WatchLogger {
    
    static func debug(items: Any) {
#if DEBUG
        print("Watch：\(items)")
#endif
    }
}
