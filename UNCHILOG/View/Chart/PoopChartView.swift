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
        let targetYearAndMonth = rootEnvironment.getCurrentYearAndMonth().yearAndMonth
        
        guard let currentDates = rootEnvironment.currentDates[safe: 1] else { return [] }
        
        let dateFormatUtility = DateFormatUtility(format: "yyyy年MM月")
        let targetDate = dateFormatUtility.getDate(str: targetYearAndMonth)
        let components = dateFormatUtility.convertDateComponents(date: targetDate)
        guard let year = components.year, let month = components.month else { return [] }
        
        // 指定されている年月だけのデータに絞り込む
        let list = poopViewModel.poops.filter {
            guard let createdAt = $0.createdAt else { return false }
            let components2 = dateFormatUtility.convertDateComponents(date: createdAt)
            guard let year2 = components2.year, let month2 = components2.month else { return false }
            return year == year2 && month == month2
        }
        
        // createdAt日付（時間は無視）ごとにPoopオブジェクトをグループ化して数を数える
        var groupedCounts = Dictionary(grouping: list) { (poop) -> Date in
            let components = dateFormatUtility.convertDateComponents(date: poop.wrappedCreatedAt, components: [.year, .month, .day])
            return dateFormatUtility.convertDate(components: components)
        }.mapValues { $0.count }
        
        for scdate in currentDates {
            guard let date = scdate.date else { continue }
            let components = dateFormatUtility.convertDateComponents(date: date, components: [.year, .month, .day])
            let formatDate = dateFormatUtility.convertDate(components: components)
            
            if !groupedCounts.keys.contains(formatDate) {
                groupedCounts[formatDate] = 0
            }
        }
        
        // タプルに変換
        let result = groupedCounts.map { (createdAt, count) in
            return (createdAt: createdAt, count: count)
        }
        return result.sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    
    public func getMax() -> Int {
        return showCurrentData.map({ $0.count }).max() ?? showCurrentData.count
    }
    
    var body: some View {
        VStack {
            
            YearAndMonthSelectionView(showBackButton: true)
            
            VStack {
                if getMax() == 0 {
                    ZStack {
                        // スワイプジェスチャーを聞かせるために全体に広がる白色のView
                        Color.white
                        MrPoopMessageView(msg: "うんちの記録がありません。")
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
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
                                if poop.count != 0 {
                                    Image("noface_poop")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                }
                            }.annotation {
                                if poop.count != 0 {
                                    Text("\(poop.count)")
                                        .foregroundStyle(.exText)
                                        .offset(y: 12)
                                }
                            }
                            
                        }.frame(width: DeviceSizeManager.deviceWidth * 2.5)
                            .padding()
                        // iOS17以降のみ　表示範囲を狭めて横スクロール可能にする
                        // 今は暫定的にScrollViewで対応
                        // .chartScrollableAxes(.horizontal)
                        // .chartXVisibleDomain(length: 5)
                            .chartYScale(domain: 0...getMax() + 1)
                            .chartYAxis {
                                AxisMarks(position: .leading) { value in
                                    AxisValueLabel {
                                        if let intValue = value.as(Int.self) {
                                            Text("\(intValue) 回")
                                        }
                                    }
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .stride(by: .day, count: 2)) { value in
                                    AxisGridLine()
                                    AxisTick()
                                    // この形式にすると単位を付与できない
//                                    AxisValueLabel(format: .dateTime.day())
                                    AxisValueLabel {
                                        if let dateValue = value.as(Date.self) {
                                            // dateFormatUtilityをここでインスタンス化しないとフリーズする
                                            Text("\(DateFormatUtility(format: "d").getString(date: dateValue)) 日")
                                        }
                                    }
                                }
                            }
                    }
                    
                }
                
            }
            // 一旦廃止
//            .simultaneousGesture(
//                DragGesture()
//                    .onEnded {value in
//                        let start = value.startLocation.x
//                        let end = value.location.x
//                        if start > end {
//                            rootEnvironment.forwardMonth()
//                        } else if start < end {
//                            rootEnvironment.backMonth()
//                        }
//                    }
//            )
            
            AdMobBannerView()
                .frame(height: 60)
            
        }.padding(.bottom, 25)
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    PoopChartView()
}
