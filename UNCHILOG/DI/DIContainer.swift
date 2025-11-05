//
//  DIContainer.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/20.
//

import Foundation
import Swinject
import SCCalendar

final class DIContainer: @unchecked Sendable {
    static let shared = DIContainer()

    // FIXME: モック切り替えフラグ
    private static let isTest: Bool = false

    private let container: Container

    private init() {
        container = Container { c in
            Self.registerRepositories(c)
            Self.registerServices(c)
            Self.registerViewModels(c)
        }
    }

    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("依存解決に失敗しました: \(type)")
        }
        return resolved
    }
}

// MARK: - Repository Registration

private extension DIContainer {
    static func registerRepositories(_ c: Container) {
        // Repository
        c.register(UserDefaultsRepository.self) { _ in UserDefaultsRepository() }
        c.register(KeyChainRepository.self) { _ in KeyChainRepository() }
        c.register(BiometricAuthRepository.self) { _ in BiometricAuthRepository() }
        // c.register(InAppPurchaseRepository.self) { _ in InAppPurchaseRepository() }
        c.register(SCCalenderRepository.self) { _ in SCCalenderRepository() }
    }
}

// MARK: - Service Registration

private extension DIContainer {
    static func registerServices(_ c: Container) {
    }
}

// MARK: - ViewModel Registration

private extension DIContainer {
    static func registerViewModels(_ c: Container) {
//        // RootEnvironment
//        c.register(RootEnvironment.self) { r in
//            RootEnvironment(
//                repository: r.resolve(RealmRepository.self)!,
//                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
//                keyChainRepository: r.resolve(KeyChainRepository.self)!,
//                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!,
//                notificationRequestManager: r.resolve(NotificationRequestManager.self)!,
//                remoteConfigManager: r.resolve(RemoteConfigManager.self)!
//            )
//        }
//
//        c.register(RootViewModel.self) { r in
//            RootViewModel(
//                localRepository: r.resolve(RealmRepository.self)!,
//                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
//            )
//        }
//
//       
//
//        // Setting
//        c.register(SettingViewModel.self) { r in
//            SettingViewModel(
//                repository: r.resolve(RealmRepository.self)!,
//                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
//                keyChainRepository: r.resolve(KeyChainRepository.self)!
//            )
//        }
//
//        // Setting > AppLock
//        c.register(AppLockViewModel.self) { r in
//            AppLockViewModel(
//                repository: r.resolve(RealmRepository.self)!,
//                keyChainRepository: r.resolve(KeyChainRepository.self)!,
//                biometricAuthRepository: r.resolve(BiometricAuthRepository.self)!
//            )
//        }
//
//        // Setting > AppLockInput
//        c.register(AppLockInputViewModel.self) { r in
//            AppLockInputViewModel(
//                keyChainRepository: r.resolve(KeyChainRepository.self)!
//            )
//        }
    }
}
