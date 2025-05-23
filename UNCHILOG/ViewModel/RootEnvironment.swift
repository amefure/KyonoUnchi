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
    
    private let dateFormatUtility = DateFormatUtility()
    
    // MARK: Calendar ロジック
    @Published var currentDates: [[SCDate]] = []
    @Published private(set) var currentYearAndMonth: [SCYearAndMonth] = []
    @Published private(set) var dayOfWeekList: [SCWeek] = []
    /// アプリに表示しているカレンダー年月インデックス番号
    @Published var displayCalendarIndex: CGFloat = 0
    
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
    private let poopRepository: PoopRepository
    private let watchConnectRepository: WatchConnectRepository
    
    private var cancellables: Set<AnyCancellable> = []
    

    private init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        scCalenderRepository = repositoryDependency.scCalenderRepository
        poopRepository = repositoryDependency.poopRepository
        watchConnectRepository = repositoryDependency.watchConnectRepository
        
        getInitWeek()
        getEntryMode()
        getAppLock()
        getCountInterstitial()

        scCalenderRepository.currentDates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dates in
                guard let self else { return }
                self.currentDates = dates
            }.store(in: &cancellables)
        
        scCalenderRepository.currentYearAndMonth
            .sink { [weak self] currentYearAndMonth in
                guard let self else { return }
                self.currentYearAndMonth = currentYearAndMonth
            }.store(in: &cancellables)
        
        scCalenderRepository.dayOfWeekList
            .sink { [weak self] list in
                guard let self else { return }
                self.dayOfWeekList = list
            }.store(in: &cancellables)
        
        scCalenderRepository.displayCalendarIndex
            .sink { [weak self] index in
                guard let self else { return }
                self.displayCalendarIndex = CGFloat(index)
            }.store(in: &cancellables)
        
        setFirstWeek(week: initWeek)
        
        watchConnectRepository.entryDate
            .sink { [weak self] date in
                guard let self else { return }
                self.poopRepository.addPoop(createdAt: date)
                self.scCalenderRepository.updateCalendar()
            }.store(in: &cancellables)
    }
}

// MARK: - SCCalender
extension RootEnvironment {
    
    /// 年月ページを1つ進める
    public func forwardMonthPage() {
        let count: Int = currentYearAndMonth.count
        displayCalendarIndex = min(displayCalendarIndex + 1, CGFloat(count))
        // 最大年月まで2になったら翌月を追加する
        if displayCalendarIndex == CGFloat(count) - 2 {
            addNextMonth()
        }
    }
    
    /// 年月ページを1つ戻る
    public func backMonthPage() {
        if displayCalendarIndex == 2 {
            // 残り年月が2になったら前月を12ヶ月分追加する
            addPreMonth()
            // 2のタイミングで12ヶ月分追加するのでインデックスを+10
            displayCalendarIndex = displayCalendarIndex + 10
        } else {
            displayCalendarIndex = displayCalendarIndex - 1
        }
    }
    
    /// 現在表示中の年月を取得する
    public func getCurrentYearAndMonth() -> SCYearAndMonth {
        return currentYearAndMonth[safe: Int(displayCalendarIndex)] ?? SCYearAndMonth(year: 2025, month: 1)
    }
   
    /// 格納済みの最新月の翌月を追加する
    private func addNextMonth() {
        let result = scCalenderRepository.addNextMonth()
        showOutOfRangeCalendarDialog = !result
    }

    /// 格納済みの最古月の前月を12ヶ月分追加する
    private func addPreMonth() {
        let result = scCalenderRepository.addPreMonth()
        showOutOfRangeCalendarDialog = !result
    }
    
    /// 週始まりを設定
    public func setFirstWeek(week: SCWeek) {
        scCalenderRepository.setFirstWeek(week)
    }
        
    /// 今月にカレンダーを移動
    public func moveTodayCalendar() {
        // 今月の年月を取得
        let (year, month) = dateFormatUtility.getDateYearAndMonth()
        
        guard let displayYearAndMonth = currentYearAndMonth[safe: Int(displayCalendarIndex)] else { return }
        // 今月を表示しているなら更新しない
        guard displayYearAndMonth.month != month else { return }
        guard let todayIndex = currentYearAndMonth.firstIndex(where: { $0.year == year && $0.month == month }) else { return }
        displayCalendarIndex = CGFloat(todayIndex)
    }
    
    /// Poopが追加された際にカレンダー構成用のデータも更新
    public func addPoopUpdateCalender(createdAt: Date) {
        let (year, date) = getUpdateCurrentDateIndex(createdAt: createdAt)
        if year != -1 && date != -1 {
            currentDates[year][date].count += 1
        }
    }
    /// Poopが削除された際にカレンダー構成用のデータも更新
    public func deletePoopUpdateCalender(createdAt: Date) {
        let (year, date) = getUpdateCurrentDateIndex(createdAt: createdAt)
        if year != -1 && date != -1 {
            currentDates[year][date].count -= 1
        }
    }
    
    // 更新対象のインデックス番号を取得する
    private func getUpdateCurrentDateIndex(createdAt: Date) -> (Int, Int) {
        // 月でフィルタリング
        guard let index = currentYearAndMonth.firstIndex(where: { $0.month == dateFormatUtility.getDateYearAndMonth(date: createdAt).month }) else { return (-1, -1) }
        // 更新対象のSCDateを取得
        guard let index2 = currentDates[index].firstIndex(where: {
            if let date = $0.date {
                return dateFormatUtility.checkInSameDayAs(date: date, sameDay: createdAt)
            } else {
                return false
            }
        }) else { return (-1, -1) }
        return (index, index2)
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
    
    /// アプリアイコン取得
    public func getAppIcon() -> String {
        userDefaultsRepository.getStringData(key: UserDefaultsKey.APP_ICON_NAME, initialValue: "AppIcon")
    }

    /// アプリアイコン登録
    public func saveAppIcon(iconName: String) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.APP_ICON_NAME, value: iconName)
    }
}
