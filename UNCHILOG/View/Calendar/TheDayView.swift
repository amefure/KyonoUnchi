//
//  TheDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayView: View {
    
    private let dateFormatUtility = DateFormatUtility()
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    public var theDay: SCDate
    public var poops: [Poop]
    
    @State private var isToday = false
    @State private var count = 0
    
    private func poopCount() -> Int {
        let list = poops.filter({ $0.getDate() == theDay.getDate() })
        return list.count
    }
    
    private func getIsToday() -> Bool {
        let today = dateFormatUtility.convertDateComponents(date: DateFormatUtility.today)
        guard let year = today.year,
              let month = today.month,
              let day = today.day else { return false }
        return (theDay.year == year && theDay.month == month && theDay.day == day)
    }
    
    private var poopIconWidth: CGFloat {
        DeviceSizeManager.deviceWidth / 7
    }

    var body: some View {
        VStack {
            if theDay.day == -1 {
                EmptyView()
            } else {
                NavigationLink {
                    TheDayDetailView(theDay: theDay)
                } label: {
                    VStack {
                        Text("\(theDay.day)")
                            .frame(width: 30, height: 30)
                            .background(isToday ? Color.exSub : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .foregroundStyle(isToday ? Color.white : theDay.dayColor())
                            .padding(.top, 2)
                        
                        Spacer()
                        
                        if count != 0 {
                            ZStack {
                                Image("noface_poop")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: poopIconWidth)
                                    .scaleEffect(1.3)
                                
                                Text("\(count)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .offset(y: 5)
                            }.frame(width: poopIconWidth)
                        }
                        
                    }
                }.simultaneousGesture(
                    TapGesture()
                        .onEnded({ _ in
                            rootEnvironment.addCountInterstitial()
                        })
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .overlay {
            Rectangle()
                .stroke(.gray , lineWidth: 0.5)
        }
        .onAppear {
            count = poopCount()
            isToday = getIsToday()
        }
    }
}

#Preview {
    TheDayView(theDay: SCDate.demo, poops: [])
}
