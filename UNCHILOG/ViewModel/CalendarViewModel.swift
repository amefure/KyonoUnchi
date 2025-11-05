//
//  PoopCalendarViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/02.
//
//
@preconcurrency import Combine
import SCCalendar
import UIKit

@Observable
final class CalendarState {
    /// カレンダー表示の年月
    fileprivate(set) var yearAndMonths: [SCYearAndMonth] = []
    /// 曜日リスト
    fileprivate(set) var dayOfWeekList: [SCWeek] = []
    /// アプリに表示しているカレンダー年月インデックス番号
    fileprivate(set) var displayCalendarIndex: CGFloat = 0
    /// 曜日始まり
    fileprivate(set) var initWeek: SCWeek = .sunday
    
    
    var showOutOfRangeCalendarDialog: Bool = false
    // 詳細ページで表示するダイアログ
    var showSimpleEntryDetailDialog: Bool = false
}

final class CalendarViewModel {
    private let dateFormatUtility = DateFormatUtility()

    let state = CalendarState()

    /// カレンダーをイニシャライズしたかどうか
    private var isInitializeFlag: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    private var updateCancellable: AnyCancellable?

    /// `Repository`
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let scCalenderRepository: SCCalenderRepository
    private let poopRepository: PoopRepository
    private let watchConnectRepository: WatchConnectRepository
    

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        keyChainRepository = repositoryDependency.keyChainRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        scCalenderRepository = repositoryDependency.scCalenderRepository
        poopRepository = repositoryDependency.poopRepository
        watchConnectRepository = repositoryDependency.watchConnectRepository

        getInitWeek()

        state.dayOfWeekList = setFirstWeek(week: state.initWeek)

        // 初回描画用に最新月だけ取得して表示する
        state.yearAndMonths = scCalenderRepository.fetchInitYearAndMonths()
        
        scCalenderRepository.displayCalendarIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                state.displayCalendarIndex = CGFloat(index)
            }.store(in: &cancellables)

        scCalenderRepository.yearAndMonths
            .receive(on: DispatchQueue.main)
            .sink { [weak self] yearAndMonths in
                guard let self else { return }
                state.yearAndMonths = yearAndMonths
            }.store(in: &cancellables)

        scCalenderRepository.dayOfWeekList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                guard let self else { return }
                state.dayOfWeekList = list
            }.store(in: &cancellables)
        
        watchConnectRepository.entryDate
            .sink { [weak self] date in
                guard let self else { return }
                self.poopRepository.addPoop(createdAt: date)
               // self.scCalenderRepository.updateCalendar()
            }.store(in: &cancellables)
    }

    deinit {
        updateCancellable?.cancel()
    }

    func onAppear() {
        if !isInitializeFlag {
            // リフレッシュしたいため都度取得する
          //  let users: [User] = localRepository.readAllObjs()
            //scCalenderRepository.initialize(initWeek: state.initWeek, entities: users)
            isInitializeFlag = true
        }

     
    }

    func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - SCCalender

extension CalendarViewModel {
    /// 年月ページを1つ進める
    func forwardMonthPage() {
        scCalenderRepository.forwardMonthPage()
    }

    /// 年月ページを1つ戻る
    func backMonthPage() {
        scCalenderRepository.backMonthPage()
    }

    /// 現在表示中の年月を取得する
    func getCurrentYearAndMonth() -> SCYearAndMonth {
        state.yearAndMonths[safe: Int(state.displayCalendarIndex)] ?? SCYearAndMonth(year: 2025, month: 1, dates: [])
    }

    /// 週始まりを設定
    func setFirstWeek(week: SCWeek) -> [SCWeek] {
        scCalenderRepository.setFirstWeek(week)
    }

    /// 今月にカレンダーを移動
    func moveTodayCalendar() {
        scCalenderRepository.moveTodayCalendar()
    }
}

// MARK: - UserDefaults

extension CalendarViewModel {
    /// 週始まりを取得
    private func getInitWeek() {
        state.initWeek = userDefaultsRepository.getInitWeek()
    }
    
//    /// Poopが追加された際にカレンダー構成用のデータも更新
//    public func addPoopUpdateCalender(createdAt: Date) {
//        let (year, date) = getUpdateCurrentDateIndex(createdAt: createdAt)
//        if year != -1 && date != -1 {
//            state.currentDates[year][date].count += 1
//        }
//    }
//    /// Poopが削除された際にカレンダー構成用のデータも更新
//    public func deletePoopUpdateCalender(createdAt: Date) {
//        let (year, date) = getUpdateCurrentDateIndex(createdAt: createdAt)
//        if year != -1 && date != -1 {
//            state.currentDates[year][date].count -= 1
//        }
//    }
//    // 更新対象のインデックス番号を取得する
//    private func getUpdateCurrentDateIndex(createdAt: Date) -> (Int, Int) {
//        // 月でフィルタリング
//        guard let index = state.currentYearAndMonth.firstIndex(where: { $0.month == dateFormatUtility.getDateYearAndMonth(date: createdAt).month }) else { return (-1, -1) }
//        // 更新対象のSCDateを取得
//        guard let index2 = state.currentDates[index].firstIndex(where: {
//            if let date = $0.date {
//                return dateFormatUtility.checkInSameDayAs(date: date, sameDay: createdAt)
//            } else {
//                return false
//            }
//        }) else { return (-1, -1) }
//        return (index, index2)
//    }
}
