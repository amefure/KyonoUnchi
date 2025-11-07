//
//  PoopInputViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/06.
//

import SwiftUI
import SCCalendar

@Observable
final class PoopInputViewState {
    
    fileprivate(set) var targetPoop: Poop? = nil
    
    var color: PoopColor = .darkBrown
    var shape: PoopShape = .normal
    var volume: PoopVolume = .medium
    var volumeNum: Float = 3
    var hardnessNum: Float = 3
    var memo: String = ""
    var createdAt: Date = Date()
    
    fileprivate func setUpPoop(simpleCreatedAt: Date) {
        if let poop = targetPoop {
            color = PoopColor(rawValue: poop.wrappedColor) ?? .brown
            shape = PoopShape(rawValue: poop.wrappedShape) ?? .normal
            volume = PoopVolume(rawValue: poop.wrappedVolume) ?? .medium
            volumeNum = Float(volume.rawValue)
            memo = poop.wrappedMemo
            createdAt = poop.date
            
            // シンプルで登録された場合は自動で初期値を設定しておく
            if color == .undefined {
                color = .darkBrown
                shape = .normal
                volume = .medium
                volumeNum = Float(volume.rawValue)
            }
            
        } else {
            // 現在時間を格納した該当の日付を生成
            createdAt = simpleCreatedAt
        }
    }
}

final class PoopInputViewModel {
    var state = PoopInputViewState()

    private let localRepository: WrapLocalRepositoryProtocol
    
    init(
        localRepository: WrapLocalRepositoryProtocol,
    ) {
        self.localRepository = localRepository
    }
    
    
    func onAppear(
        poopId: UUID?,
        theDay: Date?
    ) {
        if let poopId {
            state.targetPoop = localRepository.fetchSinglePoop(id: poopId)
        }
       
        // 現在時間を格納した該当の日付を生成
        let simpleCreatedAt = DateFormatUtility().combineDateWithCurrentTime(theDay: theDay ?? Date())
        state.setUpPoop(simpleCreatedAt: simpleCreatedAt)
    }
    
    
    func createOrUpdatePoop() {
        if let poop = state.targetPoop {
            updatePoop(poop)
        } else {
            addPoop()
        }
    }
    
    private func addPoop() {
        localRepository.addPoop(
            color: state.color,
            shape: state.shape,
            volume: state.volume,
            memo: state.memo,
            createdAt: state.createdAt
        )
    }

    private func updatePoop(_ poop: Poop) {
        localRepository.updatePoop(
            id: poop.wrappedId,
            color: state.color,
            shape: state.shape,
            volume: state.volume,
            memo: state.memo,
            createdAt: state.createdAt
        )
    }
}

