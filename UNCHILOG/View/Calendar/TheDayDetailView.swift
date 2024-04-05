//
//  PoopDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayDetailView: View {
    public var theDay: SCDate
    
    var poopList: [Poop] {
        let list = poopViewModel.poops.filter({ $0.getDate() == theDay.getDate() })
        return list
    }
    
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    
    @State private var poop: Poop? = nil
    @State private var showDeleteDialog = false
    @State private var showEditInputView = false
    
    
    var body: some View {
        VStack {
            
            HStack {
                
                Text(theDay.getDate(format: "yyyy年M月d日"))
                
                EntryButton(date: theDay.date ?? Date())
            }
            
            if poopList.count == 0 {
                Text("うんちの記録がありません。")
            } else {
                List {
                    ForEach(poopList) { poop in
                        HStack {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .frame(width: 2, height: 20)
                                Text(poop.getTime())
                                    .frame(width: 90)
                                Rectangle()
                                    .frame(width: 2, height: 20)
                            }
                            
                            Spacer()
                            
                            if let volume = PoopVolume(rawValue: poop.wrappedVolume),
                               volume != .undefined {
                                volume.image
                            }
                            
                            if let shape = PoopShape(rawValue: poop.wrappedShape),
                               shape != .undefined {
                                shape.image
                            }
                            
                            if let hardness = PoopHardness(rawValue: poop.wrappedHardness),
                               hardness != .undefined {
                                hardness.image
                            }
                            
                            Text(poop.wrappedMemo)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            // 右スワイプ：削除アクション
                            Button(role: .none) {
                                self.poop = poop
                                showDeleteDialog = true
                            } label: {
                                Image(systemName: "trash")
                            }.tint(.exNegative)
                        }.swipeActions(edge: .leading, allowsFullSwipe: false) {
                            // 左スワイプ：編集アクション
                            Button(role: .none) {
                                self.poop = poop
                                showEditInputView = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }.tint(.exPositive)
                        }
                    }
                }.listStyle(GroupedListStyle())
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
        ).navigationDestination(isPresented: $showEditInputView) {
            PoopInputView(theDay: theDay.date, poop: poop)
        }
    }
}

#Preview {
    TheDayDetailView(theDay: SCDate.demo)
}
