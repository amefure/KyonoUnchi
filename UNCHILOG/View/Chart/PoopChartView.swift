//
//  PoopChartView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/30.
//

import SwiftUI
import Charts

struct PoopChartView: View {
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    // チャートで表示する年月のデータのみ抽出
    private var showCurrentData: [Poop] {
        guard let currentYearAndMonth = rootEnvironment.currentYearAndMonth?.yearAndMonth else { return [] }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月"
        guard let currentDate = dateFormatter.date(from: currentYearAndMonth) else { return [] }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let year = components.year, let month = components.month else { return [] }
        
        return poopViewModel.poops.filter {
            guard let createdAt = $0.createdAt else { return false }
            let components2 = calendar.dateComponents([.year, .month], from: createdAt)
            guard let year2 = components2.year, let month2 = components2.month else { return false }
            
            return year == year2 && month == month2
        }
    }

    
    var body: some View {
        VStack {
            
            YearAndMonthSelectionView()
            
            Chart(showCurrentData) { poop in
                LineMark(
                    x: .value("年月日", poop.wrappedCreatedAt),
                    y: .value("点数", poop.hardness)
                ).foregroundStyle(.gray)
            }.padding()
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 2)) {
                        AxisGridLine()
                        AxisTick()
                      // AxisValueLabel(format: .dateTime.year().month(.defaultDigits).day())
                        AxisValueLabel(format: .dateTime.day())
                    }
                }.onAppear {
                    print("----",poopViewModel.poops.count)
                }
        }
    }
}

#Preview {
    PoopChartView()
}
