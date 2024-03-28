//
//  PoopCalendarView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct PoopCalendarView: View {
    @ObservedObject private var calenderViewModel = SCCalenderViewModel.shared
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    var body: some View {
        VStack {
            HStack {
                Button {
                    let result = calenderViewModel.backMonth()
                    rootEnvironment.showOutOfRangeCalendar = !result
                    
                } label: {
                    Text("Sub")
                }
                
                Text(calenderViewModel.currentYearAndMonth?.yearAndMonth ?? "")
                
                Button {
                    let result = calenderViewModel.forwardMonth()
                    rootEnvironment.showOutOfRangeCalendar = !result
                } label: {
                    Text("add")
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                ForEach(calenderViewModel.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                }
            }
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                    ForEach($calenderViewModel.currentDate) { theDay in
                        TheDayView(theDay: theDay, poops: poopViewModel.poops)
                    }
                }
            }
        }
    }
}



#Preview {
    PoopCalendarView()
}
