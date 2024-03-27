//
//  PoopDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayDetailView: View {
    public var poops: [Poop] = []
    public var theDay: SCDate
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    var body: some View {
        VStack {
            Text("\(theDay.month)")
            Text("\(theDay.day)")
            
            List {
                ForEach(poops) { poop in
                    HStack {
                        NavigationLink {
                            PoopDetailView(theDay: theDay, poop: poop)
                        } label: {
                            Text(poop.getDate())
                            Text(poop.wrappedId.uuidString)
                            Text(poop.wrappedMemo)
                        }
                    }.listRowBackground(Color.indigo)
                    
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            // 右スワイプ：削除アクション
                            Button(role: .none) {
//                                self.category = category
//                                showDeleteDialog = true
                                poopViewModel.deletePoop(poop: poop)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }
            }
        }
        
    }
}

#Preview {
    TheDayDetailView(theDay: SCDate.demo)
}
