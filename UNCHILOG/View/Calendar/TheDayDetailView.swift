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
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @State private var showDeleteDialog = false
    @State private var showEditInputView = false
    @State private var isShowMemo = false
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text(theDay.getDate(format: "yyyy年M月d日"))
                }
            )
            
            AdMobBannerView()
                .frame(height: 60)
            
            if poopList.count == 0 {
                
                Spacer()
                Text("うんちの記録がありません。")
            } else {
                
                HStack(spacing: 0) {
                    Text("時間")
                        .frame(width: 90)
                    Divider()
                    
                    Text("色")
                        .frame(width: 40)
                    
                    Divider()
                    
                    Text("形")
                        .frame(width: 40)
                    
                    Divider()
                    
                    Text("量")
                        .frame(width: 60)
                    
                    Divider()
                    
                    Text("硬さ")
                        .frame(width: 40)
                    
                    Spacer()
                }.frame(height: 50)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .zIndex(3)
                
                List {
                    ForEach(poopList) { poop in
                        TheDayDetailPoopRowView(poop: poop, showDeleteDialog: $showDeleteDialog, showEditInputView: $showEditInputView)
                    }
                }.listStyle(GroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .offset(y: -30)
                    .zIndex(1)
            }
            
            Spacer()
            
            FooterView(date: theDay.date ?? Date(), isRoot: false)
            
        }.fullScreenCover(isPresented: $showEditInputView) {
            PoopInputView(theDay: theDay.date)
        }.dialog(
            isPresented: $showDeleteDialog,
            title: L10n.dialogTitle,
            message: L10n.dialogDeletePoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            negativeButtonTitle: L10n.dialogButtonCancel,
            positiveAction: {
                guard let poop = poopViewModel.selectPoop else { return }
                poopViewModel.deletePoop(poop: poop)
            },
            negativeAction: { showDeleteDialog = false }
        ).dialog(
            isPresented: $rootEnvironment.showSimpleEntryDetailDialog,
            title: L10n.dialogTitle,
            message: L10n.dialogEntryPoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: { rootEnvironment.showSimpleEntryDetailDialog = false }
        ).navigationBarBackButtonHidden()
    }
}

#Preview {
    TheDayDetailView(theDay: SCDate.demo)
}
