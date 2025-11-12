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

    @State private var isShowMemo = false
    
    /// メモ表示領域調整用の行数制限
    @State private var memoLineLimit: MemoDisplay = .singleLine
    
    private enum MemoDisplay: Int {
        case singleLine = 1
        case full = 100
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if viewModel.state.poopList.count == 0 {
                
                Spacer()
                
                Text("うんちの記録がありません。")
                
                Spacer()
            } else {
                
                List {
                    ForEach(viewModel.state.poopList) { poop in
                        poopRowView(poop: poop)
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
            .navigationTitle(theDay.getDate(format: "yyyy年M月d日") ?? "")

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
    TheDayDetailView(theDay: SCDate.demo)
}
