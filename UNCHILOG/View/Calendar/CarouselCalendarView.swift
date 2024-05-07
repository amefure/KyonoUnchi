//
//  CarouselCalendarView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/05/02.
//

import SwiftUI

struct CarouselCalendarView: View {
    
    public var yearAndMonths: [SCYearAndMonth]
    public var dates: [[SCDate]]
    
    var parentFunction: (Int) -> Void
    
    @GestureState private var dragOffset: CGFloat = 0
    // 初期描画のUI崩れ隠し用(1秒後に表示
    @State private var opacity: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            LazyHStack(spacing: 0) {
                ForEach(Array(yearAndMonths.enumerated()), id: \.element.id) { index, element in
                    VStack(spacing: 0) {
                        if dates[safe: index] != nil {
                            // LazyVGridだとスワイプ時の描画が重くなる
                            ForEach(0..<dates[index].count / 7) { rowIndex in
                                HStack(spacing: 0) {
                                    ForEach(0..<7) { columnIndex in
                                        let dataIndex = rowIndex * 7 + columnIndex
                                        if dataIndex < dates[index].count {
                                            let theDay = dates[index][dataIndex]
                                            TheDayView(theDay: theDay)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
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
                        parentFunction(newIndex)
                    }
            )
        }.animation(.interpolatingSpring(mass: 0.6, stiffness: 150, damping: 80, initialVelocity: 0.1))
            .clipped()
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    opacity = 1
                }
            }
    }
}



#Preview {
    CarouselCalendarView(yearAndMonths: [], dates: [], parentFunction: { _ in })
}
