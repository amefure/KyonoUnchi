//
//  TheDayDetailPoopRow.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/08.
//

import SwiftUI

struct TheDayDetailPoopRowView: View {
    
    public var poop: Poop
    
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @Binding var showDeleteDialog: Bool
    @Binding var showEditInputView: Bool
    @State private var isShowMemo = false
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: 2)
                    .tint(.exSub)
                Text(poop.getTime(format: "HH:mm"))
                    .frame(width: 90)
                Rectangle()
                    .frame(width: 2)
                    .tint(.exSub)
            }
            
            VStack {
                
                HStack(spacing: 0) {
                    if let color = PoopColor(rawValue: poop.wrappedColor),
                       color != .undefined {
                        color.color
                            .frame(width: 20, height: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                    }
                    
                    if let shape = PoopShape(rawValue: poop.wrappedShape),
                       shape != .undefined {
                        shape.image
                            .padding(.horizontal, 10)
                    }
                    
                    if let volume = PoopVolume(rawValue: poop.wrappedVolume),
                       volume != .undefined {
                        Text(volume.name)
                            .font(.system(size: 13))
                            .frame(width: 40)
                    }
                    
                    
                    if let hardness = PoopHardness(rawValue: poop.wrappedHardness),
                       hardness != .undefined {
                        Text(hardness.name)
                            .font(.system(size: 13))
                            .frame(width: 40)
                    }
                    
                    if !poop.wrappedMemo.isEmpty {
                        Button {
                            isShowMemo.toggle()
                        } label: {
                            Image(systemName: "doc.plaintext.fill")
                        }.buttonStyle(.borderless)
                    }
                    
                    Spacer()
                }
                
                // MARK: - MEMO：メモ
                if isShowMemo {
                    Divider() // 境界線
                    
                    HStack{
                        Text(poop.wrappedMemo)
                        Spacer()
                    }
                }
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // 右スワイプ：削除アクション
            Button(role: .none) {
                poopViewModel.selectPoop = poop
                showDeleteDialog = true
            } label: {
                Image(systemName: "trash")
            }.tint(.exNegative)
        }.swipeActions(edge: .leading, allowsFullSwipe: false) {
            // 左スワイプ：編集アクション
            Button(role: .none) {
                poopViewModel.selectPoop = poop
                showEditInputView = true
            } label: {
                Image(systemName: "square.and.pencil")
            }.tint(.exPositive)
        }
    }
}

//#Preview {
//    TheDayDetailPoopRowView()
//}
