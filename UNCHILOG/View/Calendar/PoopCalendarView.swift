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
        VStack(spacing: 0) {
            
            YearAndMonthSelectionView()
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                ForEach(rootEnvironment.dayOfWeekList, id: \.self) { week in
                    Text(week.shortSymbols)
                }
            }
            
            ScrollView {
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
                    ForEach($rootEnvironment.currentDates) { theDay in
                        TheDayView(theDay: theDay, poops: poopViewModel.poops)
                    }
                }
                
                Spacer()
                
                
                HStack {
                    
                    Spacer()
                    
                    
                    ZStack {
                        RoundChatView()
                            .fill(Color.gray)
                            .frame(width: 250, height: 50)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        Text("うんちが５日出てないよ")
                            .foregroundStyle(.white)
                            .offset(x: 10)
                    }
                    
                    
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
                }.padding(.top, 10)
                    .padding(.bottom, 25)
            }
        }
    }
}





#Preview {
    PoopCalendarView()
}
