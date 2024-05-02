//
//  YearAndMonthSelectionView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/30.
//

import SwiftUI

struct YearAndMonthSelectionView: View {
    
    public var showBackButton = false
    
    private let dateFormatUtility = DateFormatUtility()
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
                
                
                Menu {
//                    ForEach(rootEnvironment.selectYearAndMonth.reversed()) { yearAndMonth in
//                        Button {
//                            rootEnvironment.moveToDayCalendar(year: yearAndMonth.year, month: yearAndMonth.month)
//                        } label: {
//                            Text(yearAndMonth.yearAndMonth)
//                        }
//                    }
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
                    let (year, month) = dateFormatUtility.getTodayYearAndMonth()
                    rootEnvironment.moveToDayCalendar(year: year, month: month)
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
