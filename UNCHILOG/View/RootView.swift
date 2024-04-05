//
//  ContentView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI

struct RootView: View {
    
    private var dateFormatUtility = DateFormatUtility()
    
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    
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
            positiveAction: { rootEnvironment.showSimpleEntryDialog = false }
        ).onAppear {
            poopViewModel.fetchAllPoops()
        }
    }
}






#Preview {
    RootView()
}
