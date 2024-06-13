//
//  PoopViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit
import Combine

class PoopViewModel: ObservableObject {
    
    static let shared = PoopViewModel()
    
    /// 
    @Published private(set) var poops: [Poop] = []
    /// 削除/更新対象のPoop
    @Published var selectPoop: Poop? = nil
    
    private let dateFormatUtility = DateFormatUtility(format: "yyyy年M月dd日")
    
    private var repository: PoopRepository
    private let watchConnectRepository: WatchConnectRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.poopRepository
        watchConnectRepository = repositoryDependency.watchConnectRepository
        
        watchConnectRepository.entryDate.sink { _ in
        } receiveValue: { [weak self] date in
            guard let self else { return }
            // 1秒遅延させて保存を待ってからUIを更新
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.fetchAllPoops()
            }
        }.store(in: &cancellables)
        
        watchConnectRepository.sendPoopDataFlag.sink { _ in
        } receiveValue: { [weak self] date in
            guard let self else { return }
            self.sendWatchWeekPoops()
        }.store(in: &cancellables)
    }
}

// MARK: Utility
extension PoopViewModel {
    // 今日を起点として何日うんちが出ていないか
    private func findTodayDifference() -> Int {
        // 今日の日付の23:59を取得
        let endDay = dateFormatUtility.endOfDay(for: DateFormatUtility.today)
        let dates = poops.map({ $0.wrappedCreatedAt }).filter({ $0 < endDay })
        // 今日と同じ日付があれば0を返す
        if dates.contains(where: { dateFormatUtility.checkInSameDayAs(date: $0 )}) {
            return 0
        }
        // 昨日でていれば0,一昨日出ていれば1になるように計算
        var closestPastDateDifference = Int.max
        for date in dates {
            let difference = dateFormatUtility.daysDifferenceFromToday(date: date)
            if difference > 0 && difference < closestPastDateDifference {
                closestPastDateDifference = difference
            }
        }
        return closestPastDateDifference == Int.max ? 0 : closestPastDateDifference
    }
    
    public func getMessage() -> String {
        let diffrence = findTodayDifference()
        return PoopMessage.random().name(difference: diffrence)
    }
    
    /// うんち情報を辞書型に変換する
    public func dayNotifyDictionary(currentMonth: SCYearAndMonth) -> [String: [Poop]] {
        // 月毎にフィルタリング
        let filterPoops = poops.filter({ $0.getDate(format: "yyyy年M月") == currentMonth.yearAndMonth })
        let groupedRecords = Dictionary(grouping: filterPoops) { poop in
            // yyyy年M月d日の文字列とする
            return dateFormatUtility.getString(date:  dateFormatUtility.startOfDay(poop.wrappedCreatedAt))
        }
        return groupedRecords
    }
}

// MARK: CRUD
extension PoopViewModel {
    
    public func fetchAllPoops() {
        poops = repository.fetchAllPoops()
        sendWatchWeekPoops()
    }
    
    public func addPoop(
        color: PoopColor = .undefined,
        shape: PoopShape = .undefined,
        volume: PoopVolume = .undefined,
        memo: String = "",
        createdAt: Date
    ) {
        repository.addPoop(color: color, shape: shape, volume: volume, memo: memo, createdAt: createdAt)
        fetchAllPoops()
    }

    public func updatePoop(
        id : UUID,
        color: PoopColor,
        shape: PoopShape,
        volume: PoopVolume,
        memo: String,
        createdAt: Date
    ) {
        repository.updatePoop(id: id, color: color, shape: shape, volume: volume, memo: memo, createdAt: createdAt)
        // ここでは選択状態を変更しない
        // selectPoop = nil
        fetchAllPoops()
    }
    
    
    public func onAppear(){
        fetchAllPoops()
    }
    
    
    public func deletePoop(poop: Poop) {
        repository.deletePoop(id: poop.wrappedId)
        selectPoop = nil
        fetchAllPoops()
    }
}

// Watch
extension PoopViewModel {
    private func sendWatchWeekPoops() {
        if watchConnectRepository.isReachable() {
            let endToday = dateFormatUtility.endOfDay(for: Date())
            let oneWeekAgo = dateFormatUtility.calcDate(date: endToday, value: -7)
            let weekPoops = poops.filter { poop in
                poop.wrappedCreatedAt >= oneWeekAgo && poop.wrappedCreatedAt <= endToday
            }
            watchConnectRepository.send(weekPoops)
        }
    }
}
