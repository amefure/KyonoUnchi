//
//  RepositoryDependency.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit
import SCCalendar

class RepositoryDependency {
    public let poopRepository: PoopRepository
    public let biometricAuthRepository: BiometricAuthRepository
    public let keyChainRepository: KeyChainRepository
    public let userDefaultsRepository: UserDefaultsRepository
    public let scCalenderRepository: SCCalenderRepository
    public let watchConnectRepository: WatchConnectRepository
    
    static let sharedPoopRepository = PoopRepository()
    static let sharedBiometricAuthRepository = BiometricAuthRepository()
    static let sharedKeyChainRepository = KeyChainRepository()
    static let sharedUserDefaultsRepository = UserDefaultsRepository()
    static let sharedScCalenderRepository = SCCalenderRepository()
    static let sharedWatchConnectRepository = WatchConnectRepository()
    
    init() {
        poopRepository = RepositoryDependency.sharedPoopRepository
        biometricAuthRepository = RepositoryDependency.sharedBiometricAuthRepository
        keyChainRepository = RepositoryDependency.sharedKeyChainRepository
        userDefaultsRepository = RepositoryDependency.sharedUserDefaultsRepository
        scCalenderRepository = RepositoryDependency.sharedScCalenderRepository
        watchConnectRepository = RepositoryDependency.sharedWatchConnectRepository
    }
}

