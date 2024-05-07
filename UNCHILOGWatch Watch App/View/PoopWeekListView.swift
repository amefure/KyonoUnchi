//
//  ContentView.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/03.
//

import SwiftUI

struct PoopWeekListView: View {
    
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    var body: some View {
        VStack {
            
            Text("今日のうんち")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(rootEnvironment.currentDates) { theDay in
                        VStack {
                            Spacer()
                            Text("\(theDay.day)")
                            
                            if theDay.count != 0 {
                                ZStack {
                                    Image("noface_poop")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                        .offset(y: -5)
        
                                    
                                    Text("\(theDay.count)")
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
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
