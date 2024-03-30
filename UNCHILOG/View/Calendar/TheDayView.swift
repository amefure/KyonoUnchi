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
                NavigationLink {
                    if poopCount() == 0 {
                        PoopInputView(theDay: theDay.date)
                    } else {
                        TheDayDetailView(poops: poopList(), theDay: theDay)
                    }
                } label: {
                    VStack {
                        Text("\(theDay.day)")
                            .frame(width: 40, height: 40)
                            .background(isToday ? Color.exNegative : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .foregroundStyle(isToday ? Color.white : theDay.dayColor())
                            .padding(.top, 5)
                        
                        Spacer()
                        
                        if poopCount() != 0 {
                            Text("\(poopCount())")
                        }
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .overlay {
            Rectangle()
                .stroke(.gray , lineWidth: 1)
        }
    }
}

#Preview {
    TheDayView(theDay: Binding.constant(SCDate.demo), poops: [])
}
