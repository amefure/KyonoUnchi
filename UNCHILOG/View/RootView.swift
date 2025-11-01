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
    private let viewModel = RootViewModel()
    
    @State private var showInputPoopView = false
    @State private var showSetting = false
    @State private var showChart = false
    
    
    @State private var cancellables: Set<AnyCancellable> = []
        
    var body: some View {
        
        VStack(spacing: 0) {
            
            PoopCalendarView()
            
            Spacer()
        
            Color.exThema
                .frame(height: 100)
        }.alert(
            isPresented: $rootEnvironment.showOutOfRangeCalendarDialog,
            title: L10n.dialogTitle,
            message: L10n.dialogOutOfRangeCalendar,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: { rootEnvironment.showOutOfRangeCalendarDialog = false }
        ).alert(
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
            
            viewModel.onAppear()
            
            rootEnvironment.$showInterstitial.sink { result in
                if result {
                    Task {
                        await viewModel.showInterstitial()
                        rootEnvironment.resetShowInterstitial()
                    }
                    
                }
            }.store(in: &cancellables)
        }.toolbar {
            
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    showChart = true
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                        .foregroundStyle(.exThema)
                }
            }
                
 
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showSetting = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.exThema)
                }
            }
            
            
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    if rootEnvironment.entryMode == .simple {
                        // 現在時刻を取得して登録
                        let createdAt = Date()
                        poopViewModel.addPoop(createdAt: createdAt)
                        rootEnvironment.addPoopUpdateCalender(createdAt: createdAt)
                        
                        rootEnvironment.moveTodayCalendar()
                        rootEnvironment.showSimpleEntryDialog = true
                    } else {
                        showInputPoopView = true
                    }
                } label: {
                    VStack {
                        Image(systemName: "plus")
                        Text("登録")
                    }.foregroundStyle(.white)
                        .fontM(bold: true)
                }
            }

        }.fullScreenCover(isPresented: $showInputPoopView) {
            PoopInputView(theDay: Date())
        }.navigationDestination(isPresented: $showSetting) {
            SettingView()
        }.navigationDestination(isPresented: $showChart) {
            PoopChartView()
        }.toolbarBackground(.exFoundation, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
    }
}






#Preview {
    RootView()
}
