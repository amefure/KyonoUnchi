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
    
    // MARK: Calendar ロジック
    @Published var currentDates: [SCDate] = []
    @Published private(set) var currentYearAndMonth: SCYearAndMonth? = nil
    @Published private(set) var dayOfWeekList: [SCWeek] = []
    public var selectYearAndMonth: [SCYearAndMonth] {
        scCalenderRepository.selectYearAndMonth
    }
    
    // MARK: 永続化
    @Published private(set) var initWeek: SCWeek = .sunday
    @Published private(set) var entryMode: EntryMode = .detail
    @Published private(set) var appLocked = false
    

    // MARK: Dialog
    @Published var showOutOfRangeCalendarDialog: Bool = false
    @Published var showSimpleEntryDialog: Bool = false
    // 詳細ページで表示するダイアログ
    @Published var showSimpleEntryDetailDialog: Bool = false
    @Published private(set) var showInterstitial = false
    private var countInterstitial: Int = 0
   
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let scCalenderRepository: SCCalenderRepository
    
    private var cancellables: Set<AnyCancellable> = []
    

    private init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        scCalenderRepository = repositoryDependency.scCalenderRepository
        
        
        getInitWeek()
        getEntryMode()
        getAppLock()

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
        
        setFirstWeek(week: initWeek)
    }
}

// MARK: - SCCalender
extension RootEnvironment {
   
    /// 年月を1つ進める
    public func forwardMonth() {
        let result = scCalenderRepository.forwardMonth()
        showOutOfRangeCalendarDialog = !result
    }

    /// 年月を1つ戻す
    public func backMonth() {
        let result = scCalenderRepository.backMonth()
        showOutOfRangeCalendarDialog = !result
    }
    
    /// 週始まりを設定
    public func setFirstWeek(week: SCWeek) {
        scCalenderRepository.setFirstWeek(week)
    }
    
    /// カレンダー初期表示年月を指定して更新
    public func moveToDayCalendar(year: Int, month: Int) {
        scCalenderRepository.moveYearAndMonthCalendar(year: year, month: month)
    }

}

// MARK: - Status
extension RootEnvironment {
   
    /// アプリにロックがかけてあるかをチェック
    private func getAppLock() {
        appLocked = keyChainRepository.getData().count == 4
    }
    
    /// アプリのロック解除
    public func unLockAppLock() {
        appLocked = false
    }

}


// MARK: - UserDefaults
extension RootEnvironment {
    
    /// インタースティシャル広告表示完了済みにする
    public func resetShowInterstitial() {
        showInterstitial = false
    }
    
    /// インタースティシャルリセット
    public func resetCountInterstitial() {
        userDefaultsRepository.setIntData(key: UserDefaultsKey.COUNT_INTERSTITIAL, value: 0)
    }
    
    /// インタースティシャルカウント
    public func addCountInterstitial() {
        countInterstitial += 1
        userDefaultsRepository.setIntData(key: UserDefaultsKey.COUNT_INTERSTITIAL, value: countInterstitial)
        
        if countInterstitial >= AdsConfig.COUNT_INTERSTITIAL {
            showInterstitial = true
            resetCountInterstitial()
            getCountInterstitial()
        }
    }
    
    /// インタースティシャル取得
    public func getCountInterstitial() {
        countInterstitial = userDefaultsRepository.getIntData(key: UserDefaultsKey.COUNT_INTERSTITIAL)
    }
    
    /// 週始まりを取得
    private func getInitWeek() {
        let week = userDefaultsRepository.getIntData(key: UserDefaultsKey.INIT_WEEK)
        initWeek = SCWeek(rawValue: week) ?? SCWeek.sunday
    }

    /// 週始まりを登録
    public func saveInitWeek(week: SCWeek) {
        initWeek = week
        userDefaultsRepository.setIntData(key: UserDefaultsKey.INIT_WEEK, value: week.rawValue)
    }
    
    /// 登録モード取得
    private func getEntryMode() {
        let mode = userDefaultsRepository.getIntData(key: UserDefaultsKey.ENTRY_MODE)
        entryMode = EntryMode(rawValue: mode) ?? EntryMode.detail
    }

    /// 登録モード登録
    public func saveEntryMode(mode: EntryMode) {
        entryMode = mode
        userDefaultsRepository.setIntData(key: UserDefaultsKey.ENTRY_MODE, value: mode.rawValue)
    }
    
}
