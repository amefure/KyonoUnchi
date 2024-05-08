//
//  ContentView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI
import Combine

struct RootView: View {
    
    private var dateFormatUtility = DateFormatUtility()
    
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    @ObservedObject private var interstitial = AdmobInterstitialView()
    
    // MARK: - Combine
    @State private var cancellables: Set<AnyCancellable> = []
    
    init() {
        // タブを非表示
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            PoopCalendarView()
            
            FooterView()
         
        }.dialog(
            isPresented: $rootEnvironment.showOutOfRangeCalendarDialog,
            title: L10n.dialogTitle,
            message: L10n.dialogOutOfRangeCalendar,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: { rootEnvironment.showOutOfRangeCalendarDialog = false }
        ).dialog(
            isPresented: $rootEnvironment.showSimpleEntryDialog,
            title: L10n.dialogTitle,
            message: L10n.dialogEntryPoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: {
                rootEnvironment.showSimpleEntryDialog = false
                rootEnvironment.addCountInterstitial()
            }
        ).onAppear {
            poopViewModel.fetchAllPoops()
            
            interstitial.loadInterstitial()
            rootEnvironment.$showInterstitial.sink { result in
                if result {
                    interstitial.presentInterstitial()
                    rootEnvironment.resetShowInterstitial()
                }
            }.store(in: &cancellables)
        }
    }
}






#Preview {
    RootView()
}
