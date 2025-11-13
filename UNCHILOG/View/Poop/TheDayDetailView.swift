//
//  PoopDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI
import SCCalendar

struct TheDayDetailView: View {
    public let theDay: SCDate
    
    @Environment(\.rootEnvironment) private var rootEnvironment
    
    @State private var viewModel = DIContainer.shared.resolve(TheDayDetailViewModel.self)
    
    /// メモ表示領域調整用の行数制限
    @State private var memoDisplayMode: MemoDisplayMode = .singleLine
    
    var body: some View {
        VStack(spacing: 0) {
            
            if viewModel.state.poopList.count == 0 {
                
                Spacer()
                
                Text(L10n.noPoopMsg)
                
                Spacer()
            } else {
                
                List {
                    ForEach(viewModel.state.poopList) { poop in
                        PoopRowView(
                            poop: poop,
                            editAction: {
                                viewModel.selectPoop(poop, isDelete: false)
                            },
                            deleteAction: {
                                viewModel.selectPoop(poop, isDelete: true)
                            },
                            toggleMemoAction: {
                                if memoDisplayMode == .full {
                                    memoDisplayMode = .singleLine
                                } else {
                                    memoDisplayMode = .full
                                }
                            },
                            memoDisplayMode: memoDisplayMode
                        )
                    }
                }.listStyle(GroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            
            if !rootEnvironment.state.removeAds {
                AdMobBannerView()
                    .frame(height: 60)
            }
            
        }.onAppear {
            viewModel.onAppear(theDay: theDay)
        }
        .fullScreenCover(isPresented: viewModel.$state.isShowInputDetailView) {
            PoopInputView(theDay: theDay.date, poopId: viewModel.state.selectPoop?.id)
        }.alert(
            isPresented: viewModel.$state.isShowDeleteConfirmAlert,
            title: L10n.dialogTitle,
            message: L10n.dialogDeletePoop,
            positiveButtonTitle: L10n.dialogButtonDelete,
            negativeButtonTitle: L10n.dialogButtonCancel,
            positiveButtonRole: .destructive,
            positiveAction: {
                viewModel.deletePoop()
            },
            negativeAction: {
                viewModel.cancelDelete()
            }
        ).alert(
            isPresented: viewModel.$state.isShowSuccessEntryAlert,
            title: L10n.dialogTitle,
            message: L10n.dialogEntryPoop,
            positiveButtonTitle: L10n.dialogButtonOk
        ).toolbar {
 
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    if rootEnvironment.state.entryMode == .simple {
                        // 現在時刻を取得して登録
                        viewModel.addSimplePoop()
                        viewModel.state.isShowSuccessEntryAlert = true
                    } else {
                        viewModel.state.isShowInputDetailView = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.exThema)
                }
            }
        }
        .toolbarBackground(.exFoundation, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
            .navigationTitle(theDay.getDate(format: "yyyy年M月d日") ?? "")

    }
}

#Preview {
    TheDayDetailView(theDay: SCDate.demo)
}
