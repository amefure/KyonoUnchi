//
//  RootEnvironment.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/27.
//

import UIKit
import Combine

class RootEnvironment: ObservableObject {
    
    static let shared = RootEnvironment()
    
    public let today = Date()
    
    @Published var currentDates: [SCDate] = []
    @Published var currentYearAndMonth: SCYearAndMonth? = nil
    @Published var dayOfWeekList: [SCWeek] = []
    
    @Published private(set) var appLocked = false
    @Published var showOutOfRangeCalendar: Bool = false
   
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let scCalenderRepository: SCCalenderRepository
    
    private var cancellables: Set<AnyCancellable> = []
    

    private init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        scCalenderRepository = repositoryDependency.scCalenderRepository
        

        scCalenderRepository.currentDates.sink { _ in
        } receiveValue: {  [weak self] currentDates in
            guard let self else { return }
            self.currentDates = currentDates
        }.store(in: &cancellables)
        
        scCalenderRepository.currentYearAndMonth.sink { _ in
        } receiveValue: {  [weak self] currentYearAndMonth in
            guard let self else { return }
            self.currentYearAndMonth = currentYearAndMonth
        }.store(in: &cancellables)
        
        scCalenderRepository.dayOfWeekList.sink { _ in
        } receiveValue: {  [weak self] dayOfWeekList in
            guard let self else { return }
            self.dayOfWeekList = dayOfWeekList
        }.store(in: &cancellables)
    }
}

// MARK: - SCCalender
extension RootEnvironment {
   
    /// 年月を1つ進める
    public func forwardMonth() {
        let result = scCalenderRepository.forwardMonth()
        showOutOfRangeCalendar = !result
    }

    /// 年月を1つ戻す
    public func backMonth() {
        let result = scCalenderRepository.backMonth()
        showOutOfRangeCalendar = !result
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

