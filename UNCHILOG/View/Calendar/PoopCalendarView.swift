//
//  PoopCalendarView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct PoopCalendarView: View {
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    private let columns = Array(repeating: GridItem(spacing: 0), count: 7)
    
    @State private var msg = ""
    
    var body: some View {
        VStack(spacing: 0) {
            
            YearAndMonthSelectionView()
            
//            MrPoopMessageView(msg: msg)
//                .onTapGesture {
//                    msg = poopViewModel.getMessage()
//                }
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(rootEnvironment.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                        .foregroundStyle(.exText)
                        .opacity(0.8)
                }
            }
            
            CarouselView(
                yearAndMonths: rootEnvironment.currentYearAndMonth,
                dates: rootEnvironment.currentDates, poops: poopViewModel.poops) { index  in
                    if index == 1 {
                        rootEnvironment.backMonth()
                    } else {
                        rootEnvironment.forwardMonth()
                    }
                }.padding(.bottom, 25)
        }.onAppear {
            msg = poopViewModel.getMessage()
        }
    }
}


struct CarouselView: View {
    
    // コンテンツ数と内容
    public var yearAndMonths: [SCYearAndMonth]
    public var dates: [[SCDate]]
    public var poops: [Poop]
    // スワイプされた際にHStackごとビューを動かす量
    @GestureState private var dragOffset: CGFloat = 0
    private let columns = Array(repeating: GridItem(spacing: 0), count: 7)
    var parentFunction: (Int) -> Void
    @State private var opacity = 0
    
    private func getPoops(index: Int) -> [Poop] {
        if index != 1 { return [] }
        let year = yearAndMonths[index].year
        let month = yearAndMonths[index].month
        return poops.filter({ $0.getDate(format: "M") == String(month) && $0.getDate(format: "yyyy") == String(year) })
    }
    
    var body: some View {
        // 表示
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(Array(yearAndMonths.enumerated()), id: \.element.id) { index, element in
                    VStack {
//                        LazyVGrid(columns: columns, spacing: 0) {
//                            ForEach(dates[index]) { theDay in
//                                Text("\(theDay.day)")
//                                //TheDayView(theDay: theDay, poops: getPoops(index: index))
//                            }
//                        }
                        VStack(spacing: 0) {
                            ForEach(0..<dates[index].count / 7) { rowIndex in
                                HStack(spacing: 0) {
                                    ForEach(0..<7) { columnIndex in
                                        let dataIndex = rowIndex * 7 + columnIndex
                                        if dataIndex < dates[index].count {
                                            let theDay = dates[index][dataIndex]
//                                            Text("\(theDay.day)")
                                            TheDayView(theDay: theDay, poops: getPoops(index: index))
                                        }
                                    }
                                }
                            }
                        }.id(UUID())
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            // X方向にスワイプされた量だけHStackをずらす
            // dragOffsetにはスワイプされている間だけその値が格納されスワイプが終了すると0になる
            .offset(x: dragOffset)
            // スワイプが完了してcurrentIndexが変化すると[currentIndex * width]分だけHStackをずらす
            .offset(x: -(geometry.size.width))
            .gesture(
                DragGesture(minimumDistance: 0)
                    // スワイプの変化を観測しスワイプの変化分をHStackのoffsetに反映(スワイプでビューが動く部分を実装)
                    .updating(self.$dragOffset, body: { (value, state, _) in
                        // スワイプ変化量をdragOffsetに反映
                        state = value.translation.width
                        // スワイプが完了するとdragOffsetの値は0になる
                    })
                    .onEnded { value in
                        let newIndex = value.translation.width > 0 ? 1 : 0
                        print("newIndex", newIndex)
                        parentFunction(newIndex)
                    }
            )
        }.animation(.interpolatingSpring(mass: 0.6, stiffness: 150, damping: 80, initialVelocity: 0.1))
            .clipped()
            .opacity(Double(opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    opacity = 1
                }
            }
    }
}




#Preview {
    PoopCalendarView()
}
