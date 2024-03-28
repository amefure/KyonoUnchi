//
//  AppLockInputViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import UIKit

class AppLockInputViewModel: ObservableObject {
    @Published private(set) var entryFlag: Bool = false

    private let keyChainRepository: KeyChainRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
    }

    public func entryPassword(password: [String]) {
        entryFlag = true
        let pass = password.joined(separator: "")
        print("-----", pass)
        keyChainRepository.entry(value: pass)
    }
}

