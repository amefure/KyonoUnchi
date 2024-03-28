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
    var body: some View {
        VStack {
            HStack {
                Button {
                    rootEnvironment.backMonth()
                } label: {
                    Text("Sub")
                }
                
                 Text(rootEnvironment.currentYearAndMonth?.yearAndMonth ?? "")
                
                Button {
                    rootEnvironment.forwardMonth()
                } label: {
                    Text("add")
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                ForEach(rootEnvironment.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                }
            }
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                    ForEach($rootEnvironment.currentDates) { theDay in
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
