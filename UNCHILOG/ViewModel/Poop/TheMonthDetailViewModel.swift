//
//  TheMonthDetailViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/10.
//

import SwiftUI
import SCCalendar

@Observable
final class TheMonthDetailViewState {
    var isShowSuccessEntryAlert: Bool = false
    var isShowDeleteConfirmAlert: Bool = false
    var isShowInputDetailView: Bool = false
    
    fileprivate(set) var poopList: [String: [Poop]] = [:]
    /// 削除対象として選択されたデータ
    fileprivate(set) var selectPoop: Poop? = nil
}

final class TheMonthDetailViewModel: @unchecked Sendable {
    @Bindable var state = TheMonthDetailViewState()

    private let localRepository: WrapLocalRepositoryProtocol
    
    init(
        localRepository: WrapLocalRepositoryProtocol,
    ) {
        self.localRepository = localRepository
    }
    
    private var currentMonth: SCYearAndMonth?
    
    func onAppear(currentMonth: SCYearAndMonth) {
        self.currentMonth = currentMonth
        fetchAllPoops()
        tracking()
    }
    
    private func tracking() {
        _ = withObservationTracking {
            state.isShowInputDetailView
        } onChange: { [weak self] in
            self?.fetchAllPoops()
            self?.tracking()
        }
    }
    
    func selectPoop(
        _ poop: Poop,
        isDelete: Bool
    ) {
        state.selectPoop = poop
        if isDelete {
            state.isShowDeleteConfirmAlert = true
        } else {
            state.isShowInputDetailView = true
        }
    }
    
    public func addSimplePoop() {
        let df = DateFormatUtility()
        // 現在時間を格納した該当の日付を生成して登録
        let createdAt = df.combineDateWithCurrentTime(theDay: Date())
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
        guard let currentMonth else { return }
        state.poopList = dayNotifyDictionary(currentMonth: currentMonth)
    }
    
    /// うんち情報を辞書型に変換する
    private func dayNotifyDictionary(currentMonth: SCYearAndMonth) -> [String: [Poop]] {
        let df = DateFormatUtility()
        let result = localRepository.fetchAllPoops()
        // 月毎にフィルタリング
        let filterPoops = result.filter({ $0.getDate(format: "yyyy年M月") == currentMonth.yearAndMonth })
        let groupedRecords = Dictionary(grouping: filterPoops) { poop in
            // yyyy年M月d日の文字列とする
            return df.getString(date: df.startOfDay(poop.date))
        }
        return groupedRecords
    }
}

