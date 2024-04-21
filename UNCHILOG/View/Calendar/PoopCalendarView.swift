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
    
    private func getMessage() -> String {
        let diffrence = poopViewModel.findTodayDifference()
        switch diffrence {
        case 0:
            return "順調♪順調♪"
        case 30...:
            let months = diffrence / 30
            return "うんちが\(months)ヶ月出てないよ！？"
        default:
            return "うんちが\(diffrence)日出てないよ！"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            YearAndMonthSelectionView()
            
            MrPoopMessageView(msg: getMessage())
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(rootEnvironment.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                        .foregroundStyle(.exText)
                        .opacity(0.8)
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach($rootEnvironment.currentDates) { theDay in
                        TheDayView(theDay: theDay, poops: poopViewModel.poops)
                    }
                }.padding(.bottom, 25)
            }.simultaneousGesture(
                DragGesture()
                    .onEnded {value in
                        let start = value.startLocation.x
                        let end = value.location.x
                        if start > end {
                            rootEnvironment.forwardMonth()
                        } else if start < end {
                            rootEnvironment.backMonth()
                        }
                    }
            )
        }
    }
}





#Preview {
    PoopCalendarView()
}
