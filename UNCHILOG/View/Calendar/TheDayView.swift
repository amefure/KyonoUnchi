//
//  TheDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayView: View {
    @Binding var theDay: SCDate
    public var poops: [Poop]
    
    func poopList() -> [Poop] {
        let list = poops.filter({ $0.getDate() == theDay.getDate() })
        return list
    }
    
    func poopCount() -> Int {
        return poopList().count
    }

    var body: some View {
        VStack {
            if theDay.day == -1 {
                Text("")
            } else {
                if poopCount() == 0 {
                    NavigationLink {
                        PoopInputView(theDay: theDay)
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
        }
    }
}

#Preview {
    TheDayView(theDay: Binding.constant(SCDate.demo), poops: [])
}
