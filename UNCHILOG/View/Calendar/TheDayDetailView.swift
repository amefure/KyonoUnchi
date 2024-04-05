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
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text(theDay.getDate(format: "yyyy年M月d日"))
                }
            )
            
            
            Spacer()
            
            if poopList.count == 0 {
                Text("うんちの記録がありません。")
            } else {
                List {
                    ForEach(poopList) { poop in
                        HStack {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .frame(width: 2, height: 20)
                                Text(poop.getTime(format: "HH:mm"))
                                    .frame(width: 90)
                                Rectangle()
                                    .frame(width: 2, height: 20)
                            }
                            
                            Spacer()
                            
                            if let volume = PoopVolume(rawValue: poop.wrappedVolume),
                               volume != .undefined {
                                Text(volume.name)
                            }
                            
                            if let shape = PoopShape(rawValue: poop.wrappedShape),
                               shape != .undefined {
                                shape.image
                            }
                            
                            if let hardness = PoopHardness(rawValue: poop.wrappedHardness),
                               hardness != .undefined {
                                Text(hardness.name)
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
            
            Spacer()
            
            FooterView(date: theDay.date ?? Date())
            
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
        ).sheet(isPresented: $showEditInputView) {
            PoopInputView(theDay: theDay.date, poop: poop)
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    TheDayDetailView(theDay: SCDate.demo)
}
