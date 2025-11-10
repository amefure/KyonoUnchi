//
//  TheMonthDetailView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/06/12.
//

import SwiftUI
import SCCalendar

struct TheMonthDetailView: View {
    
    public var currentMonth: SCYearAndMonth
    
    @Environment(\.rootEnvironment) private var rootEnvironment
    @State private var viewModel = DIContainer.shared.resolve(TheMonthDetailViewModel.self)
    
    @State private var isShowMemo = false
    /// メモ表示領域調整用の行数制限
    @State private var memoLineLimit: MemoDisplay = .singleLine
    
    private enum MemoDisplay: Int {
        case singleLine = 1
        case full = 100
    }
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
        
            if viewModel.state.poopList.count == 0 {
                
                
                Spacer()
                
                Text("うんちの記録がありません。")
                
                Spacer()
            } else {
                
                List {
                    ForEach(viewModel.state.poopList.keys.sorted(by: { $0 > $1}), id: \.self) { date in
                        Section(header: Text(date)) {
                            if let list = viewModel.state.poopList[date] {
                                ForEach(list, id: \.id) { poop in
                                    poopRowView(poop: poop)
                                }
                            }
                        }
                    }
                }.listStyle(GroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            
        }.onAppear {
            viewModel.onAppear(currentMonth: currentMonth)
        }
        .fullScreenCover(isPresented: viewModel.$state.isShowInputDetailView) {
            PoopInputView(theDay: viewModel.state.selectPoop?.date ?? Date(), poopId: viewModel.state.selectPoop?.id)
        }.alert(
            isPresented: viewModel.$state.isShowDeleteConfirmAlert,
            title: L10n.dialogTitle,
            message: L10n.dialogDeletePoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            negativeButtonTitle: L10n.dialogButtonCancel,
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
            .navigationTitle(currentMonth.yearAndMonth)
    }
    
    private func poopRowView(poop: Poop) -> some View {
        Menu {
            
            Button(role: .none) {
                viewModel.selectPoop(poop, isDelete: false)
            } label: {
                Label("編集", systemImage: "square.and.pencil")
            }
            
            Button(role: .none) {
                viewModel.selectPoop(poop, isDelete: true)
            } label: {
                Label("削除", systemImage: "trash")
            }
            
            if !poop.wrappedMemo.isEmpty {
                Button(role: .none) {
                    if memoLineLimit == .full {
                        memoLineLimit = .singleLine
                    } else {
                        memoLineLimit = .full
                    }
                } label: {
                    Label(memoLineLimit == .singleLine ? "MEMO表示" : "戻す", systemImage: "doc.plaintext")
                }
            }
        } label: {
            
            VStack(spacing: 0) {
                
                HStack {
                    VStack(spacing: 0) {
                        
                        Rectangle()
                            .fill(.exText)
                            .frame(width: 2, height: 20)
                        
                        Text(poop.getTime(format: "HH:mm"))
                            .fontM(bold: true)
                            .foregroundStyle(.white)
                            .frame(width: 70)
                            .padding(10)
                            .background(.exText)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        Rectangle()
                            .fill(.exText)
                            .frame(width: 2, height: memoLineLimit == .singleLine ? 20 : .infinity)
                    }
                    
                    VStack {
                        
                        HStack(spacing: 0) {
                            
                            Spacer()
                            
                            if let color = PoopColor(rawValue: poop.wrappedColor),
                               color != .undefined {
                                color.color
                                    .frame(width: 20, height: 20)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            
                            Spacer()
                            
                            if let shape = PoopShape(rawValue: poop.wrappedShape),
                               shape != .undefined {
                                shape.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .padding(.horizontal, 10)
                            } else {
                                // どれかがundefinedなら全てないはずなので真ん中で詳細なしを表示する
                                Text("詳細なし")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.exText)
                            }
                            
                            Spacer()
                            
                            if let volume = PoopVolume(rawValue: poop.wrappedVolume),
                               volume != .undefined {
                                Text(volume.name)
                                    .font(.system(size: 13))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.exText)
                                    .frame(width: 70)
                            }
                            
                            Spacer()
                        }
                        
                        if !poop.wrappedMemo.isEmpty {
                            Text(poop.wrappedMemo)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.exText)
                                .lineLimit(memoLineLimit.rawValue)
                                .padding(.leading)
                        }
                    }
                }
                
                Divider()
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}
#Preview {
   // TheMonthPoopTimelineView(currentMonth: SCYearAndMonth(year: 2024, month: 12, dates: []))
}
