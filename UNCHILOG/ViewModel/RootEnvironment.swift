//
//  RootEnvironment.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/27.
//

import UIKit

class RootEnvironment: ObservableObject {
    
    static let shared = RootEnvironment()
    
    public let today = Date()
    
    @Published private(set) var appLocked = false
    @Published var showOutOfRangeCalendar: Bool = false
   
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    

    private init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        

    }
}

// MARK: - Status
extension RootEnvironment {
   
    /// アプリにロックがかけてあるかをチェック
    private func getAppLock() {
        appLocked = keyChainRepository.getData().count == 4
    }
    
    /// アプリにロックがかけてあるかをチェック
    public func unLockAppLock() {
        appLocked = false
    }

}

