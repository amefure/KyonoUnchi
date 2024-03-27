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
    
    @State private var poop: Poop? = nil
    @State private var showDeleteDialog = false
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
                                self.poop = poop
                                showDeleteDialog = true
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.exNegative)
                        }
                }
            }
        }.dialog(
            isPresented: $showDeleteDialog,
            title: L10n.dialogTitle,
            message: L10n.dialogDeletePoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            negativeButtonTitle: L10n.dialogButtonCancel,
            positiveAction: {
                guard let poop = poop else { return }
                poopViewModel.deletePoop(poop: poop)
            },
            negativeAction: { showDeleteDialog = false }
        )
        
    }
}

#Preview {
    TheDayDetailView(theDay: SCDate.demo)
}
