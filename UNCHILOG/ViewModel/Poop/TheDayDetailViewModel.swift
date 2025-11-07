//
//  TheDayDetailViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/06.
//

import SwiftUI
import SCCalendar

@Observable
final class TheDayDetailViewState {
    
    fileprivate(set) var poopList: [Poop] = []
    /// 削除対象として選択されたデータ
    fileprivate(set) var selectPoop: Poop? = nil
}

final class TheDayDetailViewModel {
    var state = TheDayDetailViewState()

    private let localRepository: WrapLocalRepositoryProtocol    
    
    init(
        localRepository: WrapLocalRepositoryProtocol,
    ) {
        self.localRepository = localRepository
    }
    
    private var poopTheDayString: String = ""
    
    func onAppear(theDay: SCDate) {
        poopTheDayString = theDay.getDate()
        fetchAllPoops()
    }
    
    func selectPoop(_ poop: Poop) {
        state.selectPoop = poop
    }
    
    
    func deletePoop() {
        guard let poop = state.selectPoop else { return }
        localRepository.deletePoop(id: poop.wrappedId)
        state.selectPoop = nil
        fetchAllPoops()
    }
    
    func cancelDelete() {
        state.selectPoop = nil
    }
    
    private func fetchAllPoops() {
        let result = localRepository.fetchAllPoops()
        state.poopList = result.filter({ $0.getDate() == poopTheDayString })
    }
}

