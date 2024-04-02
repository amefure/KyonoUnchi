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
    
    @State private var selectedTab = 1
    
    init() {
        // タブを非表示
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            TabView(selection: $selectedTab ) {
                
                
                PoopChartView()
                    .tag(0)
                
                PoopCalendarView()
                    .tag(1)
                
                SettingView()
                    .tag(2)

            }
            
            FooterView(selectedTab: $selectedTab)
         
        }.dialog(
            isPresented: $rootEnvironment.showOutOfRangeCalendar,
            title: L10n.dialogTitle,
            message: L10n.dialogOutOfRangeCalendar,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: { rootEnvironment.showOutOfRangeCalendar = false }
        ).onAppear {
            poopViewModel.fetchAllPoops()
        }
    }
}






#Preview {
    RootView()
}
