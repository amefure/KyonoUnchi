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
            
            YearAndMonthSelectionView()
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                ForEach(rootEnvironment.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
                ForEach($rootEnvironment.currentDates) { theDay in
                    TheDayView(theDay: theDay, poops: poopViewModel.poops)
                }
            }
            
            Spacer()
            
            
            HStack {
             
                Spacer()
                
                
                Text("うんちが５日出てないよ")
                
                Spacer()
                
                NavigationLink {
                    PoopInputView(theDay: Date())
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 25))
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.indigo)
                        .background(.exThema)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                }.padding(.trailing, 20)
            }
        }
    }
}





#Preview {
    PoopCalendarView()
}
