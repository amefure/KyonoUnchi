//
//  ContentView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = SCCalenderViewModel.shared
    
    @State var scdate: [SCDate] = []
    var body: some View {
        
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
                    DateView(date: date)
                }
            }
        }
        
        HStack {
    
            Button {
                viewModel.setFirstWeek(.sunday)
            } label: {
                Text("sunday")
            }

            Button {
                viewModel.setFirstWeek(.monday)
            } label: {
                Text("monday")
            }
            Button {
                viewModel.setFirstWeek(.tuesday)
            } label: {
                Text("tuesday")
            }
            Button {
                viewModel.setFirstWeek(.wednesday)
            } label: {
                Text("wednesday")
            }
        }
    }
}



struct DateView: View {
    @Binding var date: SCDate

    var body: some View {
        VStack {
            if date.date == -1 {
                Text("")
            } else {
                Text("\(date.date)")
                Text("\(date.week.shortSymbols)")
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
        .padding(10)
        .foregroundColor(.white)
    }
}


#Preview {
    ContentView()
}
