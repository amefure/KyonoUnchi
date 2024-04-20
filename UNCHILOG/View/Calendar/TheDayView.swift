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
    
    @Binding var theDay: SCDate
    public var poops: [Poop]
    
    private func poopList() -> [Poop] {
        let list = poops.filter({ $0.getDate() == theDay.getDate() })
        return list
    }
    
    private func poopCount() -> Int {
        return poopList().count
    }
    
    private var isToday: Bool {
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
                Text("")
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
                        
                        if poopCount() != 0 {
                            ZStack {
                                Image("noface_poop")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: poopIconWidth)
                                    .scaleEffect(1.3)
                                
                                Text("\(poopCount())")
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
                .stroke(.gray , lineWidth: 1)
        }
    }
}

#Preview {
    TheDayView(theDay: Binding.constant(SCDate.demo), poops: [])
}
