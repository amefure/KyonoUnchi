//
//  PoopCalendarView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct PoopCalendarView: View {
    @ObservedObject private var viewModel = SCCalenderViewModel.shared
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.backMonth()
                } label: {
                    Text("Sub")
                }
                
                Text(viewModel.currentYearAndMonth?.yearAndMonth ?? "")
                
                Button {
                    viewModel.forwardMonth()
                } label: {
                    Text("add")
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                ForEach(viewModel.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                }
            }
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                    ForEach($viewModel.currentDate) { theDay in
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
