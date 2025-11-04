//
//  TheMonthPoopTimelineView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/06/12.
//

import SwiftUI

struct TheMonthPoopTimelineView: View {
    
    public var currentMonth: SCYearAndMonth
    
    public var poopList: [String: [Poop]] {
        let list = poopViewModel.dayNotifyDictionary(currentMonth: currentMonth)
        return list
    }
    
    @StateObject private var poopViewModel = PoopViewModel.shared
    @StateObject private var rootEnvironment = RootEnvironment.shared
    
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
                    Text(currentMonth.yearAndMonth)
                }
            )
            
            AdMobBannerView()
                .frame(height: 60)
            
            if poopList.count == 0 {
                
                Spacer()
                MrPoopMessageView(msg: "うんちの記録がありません。")
                
                Spacer()
            } else {
                
                List {
                    ForEach(poopList.keys.sorted(by: { $0 > $1}), id: \.self) { date in
                        Section(header: Text(date)) {
                            if let list = poopList[date] {
                                ForEach(list, id: \.id) { notify in
                                    TheDayDetailPoopRowView(poop: notify, showDeleteDialog: $showDeleteDialog, showEditInputView: $showEditInputView
                                    )
                                }
                            }
                        }
                    }
                }.listStyle(GroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            
            FooterView(date: Date(), isRoot: false)
            
        }.fullScreenCover(isPresented: $showEditInputView) {
            PoopInputView(theDay: Date())
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
    TheMonthPoopTimelineView(currentMonth: SCYearAndMonth(year: 2024, month: 12))
}
