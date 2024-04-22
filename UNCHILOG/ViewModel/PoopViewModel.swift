//
//  PoopViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit

class PoopViewModel: ObservableObject {
    
    static let shared = PoopViewModel()
    
    @Published private(set) var poops: [Poop] = []

    private var repository: PoopRepository
    // 削除/更新対象のPoop
    @Published var selectPoop: Poop? = nil
    
   
    private let dateFormatUtility = DateFormatUtility()
    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.poopRepository
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
}

// MARK: CRUD
extension PoopViewModel {
    
    public func fetchAllPoops() {
        poops = repository.fetchAllPoops()
    
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
