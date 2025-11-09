//
//  CarouselCalendarView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/05/02.
//

import SwiftUI
import SCCalendar

struct CarouselCalendarView: View {
    
    let viewModel: CalendarViewModel
    
    /// スワイプジェスチャー用オフセット
    @GestureState private var dragOffset: CGFloat = 0

    /// スワイプ中かどうか
    @State private var isSwipe: Bool = false
    @State private var selectedDay: SCDate? = nil
    private let deviceWidth = DeviceSizeUtility.deviceWidth
    
    var body: some View {
        
        GeometryReader { geometry in
            LazyHStack(spacing: 0) {
                ForEach(viewModel.state.yearAndMonths, id: \.id) { yearAndMonth in
                    CalendarMonthView(
                        yearAndMonth: yearAndMonth,
                        onTapDay: { day in
                            selectedDay = day
                        }
                    ).equatable()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
        // スワイプ中にバナーコンテナを移動させるためのオフセット
        // dragOffsetにはスワイプされている間だけその値が格納されスワイプが終了すると0になる
        // iOS18以降からかスワイプ終了あとに0にならなくなったのでスワイプ中のみオフセットするように変更
        .offset(x: isSwipe ? dragOffset : 0)
        // スワイプ完了後にバナーコンテナ自体を移動した後に固定するためのオフセット
        .offset(x: -(viewModel.state.displayCalendarIndex * deviceWidth))
        // スワイプ完了後の動作をなめらかにするためのアニメーション
//        .animation(
//            .linear(duration: 0.2),
//            value: viewModel.state.displayCalendarIndex * deviceWidth
//        )
        .animation(.linear(duration: 0.2), value: viewModel.state.displayCalendarIndex)

        .gesture(
            DragGesture(minimumDistance: 0)
                // スワイプの変化を観測しスワイプの変化分をHStackのoffsetに反映(スワイプでビューが動く部分を実装)
                .updating($dragOffset, body: { (value, state, _) in
                    isSwipe = true
                    // スワイプ変化量をdragOffsetに反映
                    state = value.translation.width
                    // スワイプが完了するとdragOffsetの値は0になるはずだがならないときもある
                })
                .onEnded { value in
                    // value.translation.width：ドラッグを離した時の最終的な移動距離
                    // 0ならタップしただけなので処理終了
                    guard value.translation.width != 0 else { return }
                    // 1なら左スワイプ
                    // 0なら右スワイプ
                    let swipeFlag: CGFloat = value.translation.width > 0 ? 1 : 0
                   
                    isSwipe = false
                    
                    // 以下でdisplayCalendarIndexの値を変化させる
                    if swipeFlag == 1 {
                        viewModel.backMonthPage()
                    } else {
                        viewModel.forwardMonthPage()
                    }
                }
        ).navigationDestination(item: $selectedDay) { da in
            TheDayDetailView(theDay: da)
        }
    }
    /// ✅ 現在表示中＋前後1ヶ月のみ描画
//    private var visibleMonths: [SCYearAndMonth] {
//        let index = Int(viewModel.state.displayCalendarIndex)
//        return viewModel.state.yearAndMonths.enumerated().compactMap { offset, month in
//            (offset >= index - 1 && offset <= index + 1) ? month : nil
//        }
//    }
}

private struct CalendarMonthView: View, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.yearAndMonth == rhs.yearAndMonth
    }
    
    let yearAndMonth: SCYearAndMonth
    let onTapDay: (SCDate) -> Void

    var body: some View {
        VStack(spacing: 0) {
            let dates = yearAndMonth.dates
            // LazyVGridだとスワイプ時の描画が重くなる
            ForEach(0 ..< dates.count / 7, id: \.self) { rowIndex in
                HStack(spacing: 0) {
                    ForEach(0 ..< 7) { columnIndex in
                        let dataIndex: Int = rowIndex * 7 + columnIndex
                        if dataIndex < dates.count {
                            let theDay = dates[dataIndex]
                            TheDayView(theDay: theDay, onTap: onTapDay)
                                .equatable()
                        }
                    }
                }
            }
            Spacer()
        }
    }
}




#Preview {
    CarouselCalendarView(viewModel: CalendarViewModel())
}
