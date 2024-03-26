//
//  TheDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayView: View {
    @Binding var date: SCDate
    public var poops: [Poop]
    
    func poopList() -> [Poop] {
        let list = poops.filter({ $0.getDate() == date.getDate() })
        return list
    }
    
    func poopCount() -> Int {
        return poopList().count
    }

    var body: some View {
        VStack {
            if date.day == -1 {
                Text("")
            } else {
                if poopCount() == 0 {
                    NavigationLink {
                        PoopInputView()
                    } label: {
                        Text("\(date.day)")
                            .foregroundStyle(date.dayColor())
                    }
                } else {
                    NavigationLink {
                        TheDayDetailView(poops: poopList(),date: date)
                    } label: {
                        Text("\(poopCount())")
                        Text("\(date.day)")
                            .foregroundStyle(date.dayColor())
                        Text("\(date.week!.shortSymbols)")
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
    TheDayView(date: Binding.constant(SCDate(year: 2024, month: 12, day: 4)), poops: [])
}
