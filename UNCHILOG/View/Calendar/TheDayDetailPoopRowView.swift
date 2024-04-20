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
        VStack(spacing: 0) {
            
            HStack {
                VStack(spacing: 0) {
                    
                    Rectangle()
                        .fill(.exThema)
                        .frame(width: 2, height: 20)
                    
                    Text(poop.getTime(format: "HH:mm"))
                        .fontWeight(.bold)
                        .foregroundStyle(.exSub)
                        .frame(width: 90)
                        .padding()
                        .background(.exThema)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                    
                    Rectangle()
                        .fill(.exThema)
                        .frame(width: 2, height: 20)
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
                                .frame(width: 50)
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
            
            Divider()
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
            
            // 右スワイプ：編集アクション
            Button(role: .none) {
                poopViewModel.selectPoop = poop
                showEditInputView = true
            } label: {
                Image(systemName: "square.and.pencil")
            }.tint(.exText)
        }
    }
}

//#Preview {
//    TheDayDetailPoopRowView()
//}
