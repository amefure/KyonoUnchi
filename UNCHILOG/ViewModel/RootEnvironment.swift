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
    
    // MARK: Calendar ロジック
    @Published var currentDates: [SCDate] = []
    @Published private(set) var currentYearAndMonth: SCYearAndMonth? = nil
    @Published private(set) var dayOfWeekList: [SCWeek] = []
    
    // MARK: 永続化
    @Published private(set) var initWeek: SCWeek = .sunday
    @Published private(set) var appLocked = false
    
    // MARK: Dialog
    @Published var showOutOfRangeCalendar: Bool = false
   
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let scCalenderRepository: SCCalenderRepository
    
    private var cancellables: Set<AnyCancellable> = []
    

    private init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        scCalenderRepository = repositoryDependency.scCalenderRepository
        
        
        getInitWeek()
        

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
    
    /// カレンダー初期表示年月を指定して更新
    public func moveToDayCalendar() {
        let today = DateFormatUtility().convertDateComponents(date: today)
        guard let year = today.year,
              let month = today.month else { return }
        scCalenderRepository.moveYearAndMonthCalendar(year: year, month: month)
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


// MARK: - UserDefaults
extension RootEnvironment {
    /// ブラウザを取得
    private func getInitWeek() {
        let week = userDefaultsRepository.getIntData(key: UserDefaultsKey.INIT_WEEK)
        initWeek = SCWeek(rawValue: week) ?? SCWeek.sunday
    }

    /// ブラウザを登録
    public func setInitWeek(week: SCWeek) {
        initWeek = week
        userDefaultsRepository.setIntData(key: UserDefaultsKey.INIT_WEEK, value: week.rawValue)
    }
    
}
