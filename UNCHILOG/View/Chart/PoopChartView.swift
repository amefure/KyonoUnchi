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
    private var showCurrentData: [(createdAt: Date, count: Int)] {
        guard let currentYearAndMonth = rootEnvironment.currentYearAndMonth?.yearAndMonth else { return [] }
        
        let dateFormatUtility = DateFormatUtility(format: "yyyy年MM月")
        let currentDate = dateFormatUtility.getDate(str: currentYearAndMonth)
        let components = dateFormatUtility.convertDateComponents(date: currentDate)
        guard let year = components.year, let month = components.month else { return [] }
        
        // 指定されている年月だけのデータに絞り込む
        let list = poopViewModel.poops.filter {
            guard let createdAt = $0.createdAt else { return false }
            let components2 = dateFormatUtility.convertDateComponents(date: createdAt)
            guard let year2 = components2.year, let month2 = components2.month else { return false }
            return year == year2 && month == month2
        }
        
        // createdAt日付（時間は無視）ごとにPoopオブジェクトをグループ化して数を数える
        let groupedCounts = Dictionary(grouping: list) { (poop) -> Date in
            let components = dateFormatUtility.convertDateComponents(date: poop.wrappedCreatedAt, components: [.year, .month, .day])
            return dateFormatUtility.convertDate(components: components)
        }.mapValues { $0.count }

        // タプルに変換
        let result = groupedCounts.map { (createdAt, count) in
            return (createdAt: createdAt, count: count)
        }
        return result.sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    
    var body: some View {
        VStack {
            
            YearAndMonthSelectionView()
            
            if showCurrentData.count == 0 {
                Spacer()
                Text("記録がありません・")
                Spacer()
            } else {
                Chart(showCurrentData, id: \.createdAt) { poop in
                    LineMark(
                        x: .value("年月日", poop.createdAt),
                        y: .value("回数", poop.count)
                    ).foregroundStyle(.gray)
                    
                    // ポインタマーク
                    PointMark(
                        x: .value("年月日", poop.createdAt),
                        y: .value("回数", poop.count)
                    ).symbol {
                        Circle()
                            .fill()
                            .frame(width: 10, height: 10)
                    }
                    
                }.padding()
                    .chartYScale(domain: 0...showCurrentData.count + 1)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 2)) {
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.day())
                        }
                    }
            }
            
        }.padding(.bottom, 25)
            .onAppear {
                print(showCurrentData)
            }
    }
}

#Preview {
    PoopChartView()
}