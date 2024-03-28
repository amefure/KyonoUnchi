//
//  TheDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayView: View {
    
    var dateFormatUtility = DateFormatUtility()
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @Binding var theDay: SCDate
    public var poops: [Poop]
    
    func poopList() -> [Poop] {
        let list = poops.filter({ $0.getDate() == theDay.getDate() })
        return list
    }
    
    func poopCount() -> Int {
        return poopList().count
    }
    
    var isToday: Bool {
        let today = dateFormatUtility.convertDateComponents(date: rootEnvironment.today)
        guard let year = today.year,
              let month = today.month,
              let day = today.day else { return false }
        return (theDay.year == year && theDay.month == month && theDay.day == day)
    }

    var body: some View {
        VStack {
            if theDay.day == -1 {
                Text("")
            } else {
                
                if poopCount() == 0 {
                    NavigationLink {
                        PoopInputView(theDay: theDay.date)
                    } label: {
                        Text("\(theDay.day)")
                            .foregroundStyle(theDay.dayColor())
                    }
                } else {
                    NavigationLink {
                        TheDayDetailView(poops: poopList(), theDay: theDay)
                    } label: {
                        Text("\(poopCount())")
                        Text("\(theDay.day)")
                            .foregroundStyle(theDay.dayColor())
                        Text("\(theDay.week!.shortSymbols)")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .overlay {
            Rectangle()
                .stroke(.gray, lineWidth: 4)
        }.background(isToday ? Color.exNegative : Color.clear)
    }
}

#Preview {
    TheDayView(theDay: Binding.constant(SCDate.demo), poops: [])
}
