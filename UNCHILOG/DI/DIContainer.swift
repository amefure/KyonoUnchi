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
        c.register(CoreDataRepository.self) { _ in CoreDataRepository() }
        c.register(UserDefaultsRepository.self) { _ in UserDefaultsRepository() }
        c.register(KeyChainRepository.self) { _ in KeyChainRepository() }
        c.register(BiometricAuthRepository.self) { _ in BiometricAuthRepository() }
        c.register(InAppPurchaseRepository.self) { _ in InAppPurchaseRepository() }
        c.register(SCCalenderRepository.self) { _ in SCCalenderRepository() }
        c.register(WatchConnectRepository.self) { _ in WatchConnectRepository() }
        c.register(InterstitialServiceProtocol.self) { r in
            InterstitialService(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
            )
        }.inObjectScope(.container)
        c.register(WrapLocalRepositoryProtocol.self) { r in
            WrapLocalRepository(
                localRepository: r.resolve(CoreDataRepository.self)!,
            )
        }
        
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
        // RootEnvironment
        c.register(RootEnvironment.self) { r in
            RootEnvironment(
                localRepository: r.resolve(WrapLocalRepositoryProtocol.self)!,
                keyChainRepository: r.resolve(KeyChainRepository.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!,
                watchConnectRepository: r.resolve(WatchConnectRepository.self)!
            )
        }

        c.register(RootViewModel.self) { r in
            RootViewModel(
                localRepository: r.resolve(WrapLocalRepositoryProtocol.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                interstitialService: r.resolve(InterstitialServiceProtocol.self)!
            )
        }
        
        c.register(CalendarViewModel.self) { r in
            CalendarViewModel(
                localRepository: r.resolve(WrapLocalRepositoryProtocol.self)!,
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                keyChainRepository: r.resolve(KeyChainRepository.self)!,
                scCalenderRepository: r.resolve(SCCalenderRepository.self)!,
            )
        }
        
        
        // ViewModel
        c.register(TheDayDetailViewModel.self) { r in
            TheDayDetailViewModel(
                localRepository: r.resolve(WrapLocalRepositoryProtocol.self)!,
            )
        }
        
        c.register(TheMonthDetailViewModel.self) { r in
            TheMonthDetailViewModel(
                localRepository: r.resolve(WrapLocalRepositoryProtocol.self)!,
            )
        }
        
        c.register(PoopInputViewModel.self) { r in
            PoopInputViewModel(
                localRepository: r.resolve(WrapLocalRepositoryProtocol.self)!,
            )
        }

        // Setting
        c.register(SettingViewModel.self) { r in
            SettingViewModel(
                keyChainRepository: r.resolve(KeyChainRepository.self)!
            )
        }
        
        // Setting
        c.register(SelectInitWeekViewModel.self) { r in
            SelectInitWeekViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!
            )
        }
        
        
        // Setting > Purchase
        c.register(InAppPurchaseViewModel.self) { r in
            InAppPurchaseViewModel(
                userDefaultsRepository: r.resolve(UserDefaultsRepository.self)!,
                inAppPurchaseRepository: r.resolve(InAppPurchaseRepository.self)!
            )
        }
        // Setting > AppLock
        c.register(AppLockViewModel.self) { r in
            AppLockViewModel(
                keyChainRepository: r.resolve(KeyChainRepository.self)!,
                biometricAuthRepository: r.resolve(BiometricAuthRepository.self)!
            )
        }
        // Setting > AppLockInput
        c.register(AppLockInputViewModel.self) { r in
            AppLockInputViewModel(
                keyChainRepository: r.resolve(KeyChainRepository.self)!
            )
        }
    }
}
