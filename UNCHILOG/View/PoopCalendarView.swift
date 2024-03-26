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
                    ForEach($viewModel.currentDate) { date in
                        DateView(date: date, poops: poopViewModel.poops)
                    }
                }
            }
        }
    }
}

struct DateView: View {
    @Binding var date: SCDate
    public var poops: [Poop]
    
    func poopCount() -> Int {
        let list = poops.filter({ $0.getDate() == date.getDate() })
        return list.count
    }

    var body: some View {
        VStack {
            if date.day == -1 {
                Text("")
            } else {
                Text("\(poopCount())")
                Text("\(date.day)")
                Text("\(date.week!.shortSymbols)")
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
        .padding(10)
        .foregroundColor(.white)
    }
}

#Preview {
    PoopCalendarView()
}
