//
//  RepositoryDependency.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import UIKit

class RepositoryDependency: NSObject {
    public let scWeekDayRepository = SCWeekDayRepository()
    public let poopRepository = PoopRepository()
    public let iosConnectRepository = iOSConnectRepository.shared
}
