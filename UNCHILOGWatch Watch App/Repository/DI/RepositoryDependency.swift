//
//  RepositoryDependency.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import UIKit

class RepositoryDependency {
    public let poopRepository: PoopRepository
    public let scWeekDayRepository: SCWeekDayRepository
    public let iosConnectRepository: iOSConnectRepository
    
    static let sharedPoopRepository = PoopRepository()
    static let sharedSCWeekDayRepository = SCWeekDayRepository()
    static let sharediOSConnectRepository = iOSConnectRepository()
    
    init() {
        poopRepository = RepositoryDependency.sharedPoopRepository
        scWeekDayRepository = RepositoryDependency.sharedSCWeekDayRepository
        iosConnectRepository = RepositoryDependency.sharediOSConnectRepository
    }
}
