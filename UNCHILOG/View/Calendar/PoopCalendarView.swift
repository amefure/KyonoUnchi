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
    
    var body: some View {
        VStack(spacing: 0) {
            
            YearAndMonthSelectionView()
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(rootEnvironment.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                        .foregroundStyle(.exText)
                        .opacity(0.8)
                }
            }.padding(.top, 30)
            
            CarouselCalendarView()
            
            Spacer()
            
        }
    }
}


#Preview {
    PoopCalendarView()
}
