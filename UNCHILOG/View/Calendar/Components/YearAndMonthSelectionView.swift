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
    
    
    private var isTodayYearAndMonth: (year: Int, month: Int) {
        let today = dateFormatUtility.convertDateComponents(date: DateFormatUtility.today)
        guard let year = today.year,
              let month = today.month else { return (2024, 8) }
        return (year, month)
    }
    
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
                    .frame(width: 40)
                    .padding(.horizontal, 20)
                
                Button {
                    rootEnvironment.backMonth()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
                Spacer()
                
                
                Menu {
                    ForEach(rootEnvironment.selectYearAndMonth.reversed()) { yearAndMonth in
                        Button {
                            rootEnvironment.moveToDayCalendar(year: yearAndMonth.year, month: yearAndMonth.month)
                        } label: {
                            Text(yearAndMonth.yearAndMonth)
                        }
                    }
                } label: {
                    Text(rootEnvironment.currentYearAndMonth?.yearAndMonth ?? "")
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Button {
                    rootEnvironment.forwardMonth()
                } label: {
                    Image(systemName: "chevron.forward")
                }
                
                Button {
                    rootEnvironment.moveToDayCalendar(year: isTodayYearAndMonth.year, month: isTodayYearAndMonth.month)
                } label: {
                    Image("back_today")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                }.padding(.horizontal, 20)
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
