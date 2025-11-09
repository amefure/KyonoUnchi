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
    
    var isShowSuccessEntryAlert: Bool = false
    var isShowInputDetailPoop: Bool = false
    
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
    
    private var theDay: SCDate?
    
    func onAppear(theDay: SCDate) {
        self.theDay = theDay
        fetchAllPoops()
    }
    
    func selectPoop(_ poop: Poop) {
        state.selectPoop = poop
    }
    
    public func addSimplePoop() {
        let df = DateFormatUtility()
        let targetDate: Date = theDay?.date ?? Date()
        // 現在時間を格納した該当の日付を生成して登録
        let createdAt = df.combineDateWithCurrentTime(theDay: targetDate)
        let added = localRepository.addPoopSimple(createdAt: createdAt)
        // カレンダーを更新
        NotificationCenter.default.post(name: .updateCalendar, object: added)
        fetchAllPoops()
    }
    
    func deletePoop() {
        guard let poop = state.selectPoop else { return }
        // 削除すると参照が途絶えてIDが異なってしまうので先にプールしておく
        let deleteId = poop.wrappedId
        localRepository.deletePoop(id: poop.wrappedId)
        state.selectPoop = nil
        fetchAllPoops()
        // カレンダーを更新
        NotificationCenter.default.post(name: .updateCalendar, object: deleteId)
    }
    
    func cancelDelete() {
        state.selectPoop = nil
    }
    
    private func fetchAllPoops() {
        let result = localRepository.fetchAllPoops()
        let poopTheDayString: String = theDay?.getDate() ?? ""
        state.poopList = result.filter({ $0.getDate() == poopTheDayString })
    }
}

