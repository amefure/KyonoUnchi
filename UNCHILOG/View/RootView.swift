//
//  ContentView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var rootEnvironment = RootEnvironment.shared
    @State private var viewModel = RootViewModel.shared
        
    var body: some View {
        
        VStack(spacing: 0) {
            
            PoopCalendarView()
            
            Spacer()
        
            Color.exThema
                .frame(height: 100)
        }.alert(
            isPresented: $viewModel.state.isShowSuccessEntryAlert,
            title: L10n.dialogTitle,
            message: L10n.dialogEntryPoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: {
                viewModel.showOrCountInterstitial()
            }
        ).onAppear {
            viewModel.onAppear()
        }.toolbar {
            
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    viewModel.state.isShowChart = true
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                        .foregroundStyle(.exThema)
                }
            }
                
 
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    viewModel.state.isShowSetting = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.exThema)
                }
            }
            
            
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    if rootEnvironment.state.entryMode == .simple {
                        // 現在時刻を取得して登録
                        viewModel.addSimplePoop()
                      //  rootEnvironment.addPoopUpdateCalender(createdAt: Date())
                        
                       // rootEnvironment.moveTodayCalendar()
                        viewModel.state.isShowSuccessEntryAlert = true
                    } else {
                        viewModel.state.isShowInputDetailPoop = true
                    }
                } label: {
                    VStack {
                        Image(systemName: "plus")
                        Text("登録")
                    }.foregroundStyle(.white)
                        .fontM(bold: true)
                }
            }

        }.fullScreenCover(isPresented: $viewModel.state.isShowInputDetailPoop) {
            PoopInputView(theDay: Date())
        }.navigationDestination(isPresented: $viewModel.state.isShowSetting) {
            SettingView()
        }.navigationDestination(isPresented: $viewModel.state.isShowChart) {
            PoopChartView()
        }.toolbarBackground(.exFoundation, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
            .navigationBarBackButtonHidden()
            .ignoresSafeArea(edges: [.bottom])
    }
}






#Preview {
    RootView()
}
