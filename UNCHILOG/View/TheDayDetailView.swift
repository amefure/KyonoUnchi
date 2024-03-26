//
//  PoopDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayDetailView: View {
    public var poops: [Poop] = []
    public var date: SCDate
    var body: some View {
        VStack {
            Text("\(date.month)")
            Text("\(date.day)")
            
            List {
                ForEach(poops) { poop in
                    HStack {
                        NavigationLink {
                            PoopDetailView(poop: poop)
                        } label: {
                            Text(poop.getDate())
                            Text(poop.wrappedId.uuidString)
                            Text(poop.wrappedMemo)
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    TheDayDetailView(date: SCDate(year: 2024, month: 12, day: 25))
}
