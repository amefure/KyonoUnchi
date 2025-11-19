//
//  ContentView.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/03.
//

import SwiftUI
import SCCalendar

struct PoopWeekListView: View {
    
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    var body: some View {
        VStack {
            
            Text(L10n.watchWeekTitle)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(rootEnvironment.currentDates) { theDay in
                        VStack {
                            Spacer()
                            Text("\(theDay.day)")
                                .frame(width: 25, height: 25)
                                .background(theDay.isToday ? Color.exSub : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .foregroundStyle(theDay.isToday ? Color.white : theDay.dayColor())
                                .padding(.top, 3)
                            
                            Spacer()
                            
                            if theDay.entities.count != 0 {
                                ZStack {
                                    Color.exPoopYellow
                                    //Image("noface_poop")
                                        //.resizable()
                                        //.scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 60))
        
                                    
                                    Text("\(theDay.entities.count)")
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                            } else {
                                Spacer()
                                    .frame(height: 40)
                            }
                            Spacer()
                        }.frame(width: DeviceSizeManager.deviceWidth / 3)
                            .overlay {
                                Rectangle()
                                    .stroke(.gray, lineWidth: 0.5)
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    PoopWeekListView()
}
