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
    
   
    private let dateFormatUtility = DateFormatUtility()
    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.poopRepository
    }
}

// MARK: Utility
extension PoopViewModel {
    // 今日を起点として何日うんちが出ていないか
    public func findTodayDifference() -> Int {
        
        let dates = poops.map({ $0.wrappedCreatedAt })
        // 今日と同じ日付があれば0を返す
        if dates.contains(where: { dateFormatUtility.checkInSameDayAs(date: $0 )}) {
            return 0
        }
        
        var closestPastDateDifference = -1
        for date in dates {
            let difference = dateFormatUtility.daysDifferenceFromToday(date: date)
            if difference > 0 && difference < closestPastDateDifference {
                closestPastDateDifference = difference
            }
        }
        return closestPastDateDifference
    }
}

// MARK: CRUD
extension PoopViewModel {
    
    public func fetchAllPoops() {
        poops = repository.fetchAllPoops()
    
    }
    
    public func addPoop(color: PoopColor = .undefined,
                        shape: PoopShape = .undefined,
                        volume: PoopVolume = .undefined,
                        hardness: PoopHardness = .undefined,
                        memo: String = "",
                        createdAt: Date) {
        repository.addPoop(color: color, shape: shape, volume: volume, hardness: hardness, memo: memo, createdAt: createdAt)
        fetchAllPoops()
    }

    public func updatePoop(id : UUID, color: PoopColor, shape: PoopShape, volume: PoopVolume, hardness: PoopHardness, memo: String) {
        repository.updatePoop(id: id, color: color, shape: shape, volume: volume, hardness: hardness, memo: memo)
        fetchAllPoops()
    }
    
    
    public func onAppear(){
        fetchAllPoops()
    }
    
    
    public func deletePoop(poop: Poop) {
        repository.deletePoop(id: poop.wrappedId)
        fetchAllPoops()
    }
}
