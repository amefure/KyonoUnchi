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
        switch poopViewModel.findTodayDifference() {
        case 0:
            return "順調♪順調♪"
        default:
            return "うんちが\(poopViewModel.findTodayDifference())日出てないよ"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            YearAndMonthSelectionView()
            
            HStack {
                Image(systemName: "swift")
                    .font(.system(size: 25))
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.exSub)
                    .background(.exThema)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                
                Spacer()
                
                ZStack {
                    RoundChatView()
                        .fill(Color.exGray)
                        .frame(width: 250, height: 50)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                    Text(getMessage())
                        .foregroundStyle(.exText)
                        .fontWeight(.bold)
                        .offset(x: 10)
                }
                
                Spacer()
                
            }.padding(20)

            
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
