//
//  RootEnvironment.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import UIKit
import Combine
import SCCalendar

class RootEnvironment: ObservableObject {
    
    static let shared = RootEnvironment()
    // MARK: Calendar ロジック
    @Published var currentDates: [SCDate] = []
    
    private let iosConnectRepository: iOSConnectRepository
    private let scWeekDayRepository: SCWeekDayRepository
    private let poopRepository: PoopRepository
    
    private var weekPoopList: [Poop] = []

    private var cancellables: Set<AnyCancellable> = []
    
    private init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        scWeekDayRepository = repositoryDependency.scWeekDayRepository
        iosConnectRepository = repositoryDependency.iosConnectRepository
        poopRepository = repositoryDependency.poopRepository
        weekPoopList = poopRepository.fetchAllPoops()

        // メインスレッドで実行
        scWeekDayRepository.currentDates
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] currentDates in
                guard let self else { return }
                self.currentDates = currentDates
            }.store(in: &cancellables)
        
        // メインスレッドで実行
        iosConnectRepository.poopList
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] poopList in
                guard let self else { return }
                // poopListに値が流れた時点で保存まで完了している
                // 現在保存されているデータを全て削除
                self.weekPoopList.forEach { poop in
                    self.poopRepository.deletePoop(id: poop.wrappedId)
                }
                self.weekPoopList = poopList
                // カレンダー更新
                self.scWeekDayRepository.updateCalendar()
            }.store(in: &cancellables)
    }
    
    /// うんち登録
    public func requestRegisterPoop() -> Bool {
        iosConnectRepository.requestRegisterPoop()
    }
}
