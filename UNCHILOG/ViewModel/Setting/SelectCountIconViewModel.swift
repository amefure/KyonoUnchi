//
//  SelectCountIconViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/20.
//

import SwiftUI

@Observable
final class SelectCountIconState {
    private(set) var selectCountIcon: CountIconItem = .simple
    var isShowSuccessAlert: Bool = false
    fileprivate func setCountIcon(icon: CountIconItem) {
        selectCountIcon = icon
    }
}

final class SelectCountIconViewModel {
    var state = SelectCountIconState()

    /// `Repository`
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func onAppear() {
        getCountIcon()
    }

    func setCountIcon(icon: CountIconItem) {
        state.setCountIcon(icon: icon)
    }

    private func getCountIcon() {
        state.setCountIcon(icon: userDefaultsRepository.getCountIcon())
    }

    /// 回数アイコンを登録
    func registerCountIcon() {
        userDefaultsRepository.setCountIcon(state.selectCountIcon)
        state.isShowSuccessAlert = true
    }
}
