//
//  YearAndMonthSelectionView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/30.
//

import SwiftUI

struct YearAndMonthSelectionView: View {
    
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    var body: some View {
        HStack {
            
            Spacer()
                .frame(width: 30)
                .padding(.horizontal, 10)
            
            Spacer()
            
            Button {
                rootEnvironment.backMonthPage()
            } label: {
                Image(systemName: "chevron.backward")
            }.frame(width: 10)
            
            Spacer()
            
            NavigationLink {
                TheMonthPoopTimelineView(currentMonth: rootEnvironment.getCurrentYearAndMonth())
            } label: {
                Text(rootEnvironment.getCurrentYearAndMonth().yearAndMonth)
                    .frame(width: 100)
                    .fontWeight(.bold)
            }.frame(width: 100)
            
            Spacer()
            
            Button {
                rootEnvironment.forwardMonthPage()
            } label: {
                Image(systemName: "chevron.forward")
            }.frame(width: 10)
            
            Spacer()
            
            Button {
                rootEnvironment.moveTodayCalendar()
            } label: {
                Image("back_today")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }.padding(.horizontal, 10)
                .frame(width: 30)
            
          
        }.foregroundStyle(.exThema)
            .fontM(bold: true)
            .padding()
    }
}

#Preview {
    YearAndMonthSelectionView()
}
