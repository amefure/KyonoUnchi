//
//  YearAndMonthSelectionView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/30.
//

import SwiftUI

struct YearAndMonthSelectionView: View {
    
    public var showBackButton = false
    
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @State private var showChart = false
    @State private var showSetting = false
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        HeaderView(
            leadingIcon: showBackButton ? "arrow.backward" : "chart.xyaxis.line",
            trailingIcon: showBackButton ? "" : "gearshape.fill",
            leadingAction: {
                if showBackButton {
                    dismiss()
                } else {
                    showChart = true
                }
            },
            trailingAction: {
                if !showBackButton {
                    showSetting = true
                }
            },
            content: {
                Spacer()
                    .frame(width: 30)
                    .padding(.horizontal, 10)
                
                Button {
                    rootEnvironment.backMonth()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
                Spacer()
                
                
                NavigationLink {
                    TheMonthPoopTimelineView(currentMonth: rootEnvironment.currentYearAndMonth[safe: 1] ?? SCYearAndMonth(year: 2024, month: 12))
                } label: {
                    Text(rootEnvironment.getCurrentYearAndMonth())
                        .frame(width: 100)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Button {
                    rootEnvironment.forwardMonth()
                } label: {
                    Image(systemName: "chevron.forward")
                }
                
                Button {
                    rootEnvironment.moveToDayYearAndMonthCalendar()
                } label: {
                    Image("back_today")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }.padding(.horizontal, 10)
            }
        ).navigationDestination(isPresented: $showSetting) {
            SettingView()
        }.navigationDestination(isPresented: $showChart) {
            PoopChartView()
        }
    }
}

#Preview {
    YearAndMonthSelectionView()
}
