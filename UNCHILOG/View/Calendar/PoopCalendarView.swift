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
            
            CarouselCalendarView(
                yearAndMonths: rootEnvironment.currentYearAndMonth,
                dates: rootEnvironment.currentDates) { index  in
                    if index == 1 {
                        rootEnvironment.backMonth()
                    } else {
                        rootEnvironment.forwardMonth()
                    }
                }
            
            Spacer()
            
        }.onAppear {
            msg = poopViewModel.getMessage()
        }
    }
}


#Preview {
    PoopCalendarView()
}
