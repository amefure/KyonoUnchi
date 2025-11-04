//
//  PoopDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayDetailView: View {
    public var theDay: SCDate
    
    public var poopList: [Poop] {
        let list = poopViewModel.poops.filter({ $0.getDate() == theDay.getDate() })
        return list
    }
    
    @StateObject private var poopViewModel = PoopViewModel.shared
    @StateObject private var rootEnvironment = RootEnvironment.shared
    
    @State private var showDeleteDialog = false
    @State private var showEditInputView = false
    @State private var isShowMemo = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            AdMobBannerView()
                .frame(height: 60)
            
            if poopList.count == 0 {
                
                Spacer()
                
                Text("うんちの記録がありません。")
                
                Spacer()
            } else {
                
                List {
                    ForEach(poopList) { poop in
                        TheDayDetailPoopRowView(poop: poop, showDeleteDialog: $showDeleteDialog, showEditInputView: $showEditInputView)
                    }
                }.listStyle(GroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            
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
                guard let createdAt = poop.createdAt else { return }
                rootEnvironment.deletePoopUpdateCalender(createdAt: createdAt)
                poopViewModel.deletePoop(poop: poop)
            },
            negativeAction: { showDeleteDialog = false }
        ).alert(
            isPresented: $rootEnvironment.showSimpleEntryDetailDialog,
            title: L10n.dialogTitle,
            message: L10n.dialogEntryPoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: { rootEnvironment.showSimpleEntryDetailDialog = false }
        ).toolbarBackground(.exFoundation, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
            .navigationTitle(theDay.getDate(format: "yyyy年M月d日"))
    }
}

#Preview {
    TheDayDetailView(theDay: SCDate.demo)
}
