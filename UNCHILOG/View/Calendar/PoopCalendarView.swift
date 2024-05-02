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
            
            MrPoopMessageView(msg: msg)
                .onTapGesture {
                    msg = poopViewModel.getMessage()
                }
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(rootEnvironment.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                        .foregroundStyle(.exText)
                        .opacity(0.8)
                }
            }
            
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 0) {
//                    ForEach($rootEnvironment.currentDates[1]) { theDay in
//                        TheDayView(theDay: theDay, poops: poopViewModel.poops)
//                    }
//                }.padding(.bottom, 25)
//            }
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
        }.onAppear {
            msg = poopViewModel.getMessage()
        }
    }
}


struct CarouselView: View {
    
    // コンテンツ数と内容
    public var pages: [SCYearAndMonth]
    public var dates: [[SCDate]]
    // スワイプされた際にHStackごとビューを動かす量
    @GestureState private var dragOffset: CGFloat = 0
    private let columns = Array(repeating: GridItem(spacing: 0), count: 7)
    
    var parentFunction: (Int) -> Void
    
    var body: some View {
        // 表示
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(pages) { index in
                    ScrollView {
                        Text(index.yearAndMonth)
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(dates[0]) { theDay in
                                Text(String(theDay.day))
                            }
                        }.frame(width: geometry.size.width, height: geometry.size.height)
                    }.scrollContentBackground(.hidden)
                        .background(Color.blue)
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
                        let newIndex = value.translation.width > 0 ? pages.first!.month - 1 : pages.last!.month + 1
                        print("newIndex", newIndex)
                        parentFunction(newIndex)
                    }
            )
        }// アニメーションをなめらかに
        .animation(.interpolatingSpring(mass: 0.6, stiffness: 150, damping: 80, initialVelocity: 0.1))
        .clipped()
    }
}



#Preview {
    PoopCalendarView()
}
