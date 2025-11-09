//
//  ContentView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI

struct RootView: View {
    @Environment(\.rootEnvironment) private var rootEnvironment
    @State private var viewModel = RootViewModel.shared
        
    var body: some View {
        
        VStack(spacing: 0) {
            
            PoopCalendarView()
            
            AdMobBannerView()
                .frame(height: 60)
            
            HStack {
                Spacer()
                
                Button {
                    if rootEnvironment.state.entryMode == .simple {
                        // 現在時刻を取得して登録
                        viewModel.addSimplePoop()
                        viewModel.state.isShowSuccessEntryAlert = true
                    } else {
                        viewModel.state.isShowInputDetailPoop = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .fontL(bold: true)
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .overlay {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(lineWidth: 2)
                                .foregroundStyle(.white)
                        }
                        .compositingGroup()
                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                }

                Spacer()
            }.padding(.bottom, 40)
                .padding(.top)
                .background(Color.exThema)
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
