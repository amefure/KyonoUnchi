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
}

final class CalendarViewModel {
    /// シングルトン設計にしておかないと`updateCalendar`が重複実行されてしまう
    static let shared = DIContainer.shared.resolve(CalendarViewModel.self)
    
    private let dateFormatUtility = DateFormatUtility()

    var state = CalendarState()

    /// カレンダーをイニシャライズしたかどうか
    private var isInitializeFlag: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    /// `Repository`
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let scCalenderRepository: SCCalenderRepository
    private let poopRepository: WrapLocalRepositoryProtocol
    private let watchConnectRepository: WatchConnectRepository

    init(
        localRepository: WrapLocalRepositoryProtocol,
        userDefaultsRepository: UserDefaultsRepository,
        keyChainRepository: KeyChainRepository,
        scCalenderRepository: SCCalenderRepository,
        watchConnectRepository: WatchConnectRepository,
    ) {
        poopRepository = localRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.keyChainRepository = keyChainRepository
        self.scCalenderRepository = scCalenderRepository
        self.watchConnectRepository = watchConnectRepository

        getInitWeek()

        state.dayOfWeekList = setFirstWeek(week: state.initWeek)

        // 初回描画用に最新月だけ取得して表示する
        state.yearAndMonths = scCalenderRepository.fetchInitYearAndMonths()
        
        scCalenderRepository.displayCalendarIndex
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] index in
                guard let self else { return }
                state.displayCalendarIndex = CGFloat(index)
            }.store(in: &cancellables)

        scCalenderRepository.yearAndMonths
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] yearAndMonths in
                guard let self else { return }
                AppLogger.logger.debug("yearAndMonths：\(yearAndMonths.map { $0.yearAndMonth })")
                state.yearAndMonths = yearAndMonths
            }.store(in: &cancellables)

        scCalenderRepository.dayOfWeekList
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] list in
                guard let self else { return }
                state.dayOfWeekList = list
            }.store(in: &cancellables)
        
        watchConnectRepository.entryDate
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self else { return }
                let added = self.poopRepository.addPoopSimple(createdAt: date)
                NotificationCenter.default.post(name: .updateCalendar, object: added)
            }.store(in: &cancellables)
        
        // カレンダー更新用Notificationを観測
        NotificationCenter.default.publisher(for: .updateCalendar)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self else { return }
                if let obj = notification.object as? Poop {
                    for yearIndex in state.yearAndMonths.indices {
                        guard let dateIndex = state.yearAndMonths[yearIndex].dates.firstIndex(where: { $0.getDate() == obj.getDate() }) else { continue }
                        AppLogger.logger.debug("データ追加によるカレンダー更新")
                        state.yearAndMonths[yearIndex].dates[dateIndex].entities.append(obj)
                    }
                } else if let deleteId = notification.object as? UUID {
                    for yearIndex in state.yearAndMonths.indices {
                        for dateIndex in state.yearAndMonths[yearIndex].dates.indices {
                            state.yearAndMonths[yearIndex].dates[dateIndex].entities.removeAll(where: {
                                if let poop = $0 as? Poop {
                                    return poop.wrappedId == deleteId
                                } else {
                                    return false
                                }
                            })
                        }
                        AppLogger.logger.debug("データ削除によるカレンダー更新")
                    }
                } else if let _ = notification.object as? Bool {
                    AppLogger.logger.debug("始まり更新")
                    getInitWeek()
                    // リフレッシュしたいため都度取得する
                    let poops = poopRepository.fetchAllPoops()
                    scCalenderRepository.initialize(initWeek: state.initWeek, entities: poops)
                }
                
                NotificationCenter.default.post(name: .updateCalendar, object: nil)
            }.store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    func onAppear() {
        if !isInitializeFlag {
            // リフレッシュしたいため都度取得する
            let poops = poopRepository.fetchAllPoops()
            scCalenderRepository.initialize(initWeek: state.initWeek, entities: poops)
            isInitializeFlag = true
        }

    }

    func onDisappear() {
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
}
