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
    @State private var memoLineLimit = 1
    
    var body: some View {
        Menu {
            
            Button(role: .none) {
                poopViewModel.selectPoop = poop
                showEditInputView = true
            } label: {
                Label("編集", systemImage: "square.and.pencil")
            }
            
            Button(role: .none) {
                poopViewModel.selectPoop = poop
                showDeleteDialog = true
            } label: {
                Label("削除", systemImage: "trash")
            }
            
            if !poop.wrappedMemo.isEmpty {
                Button(role: .none) {
                    if memoLineLimit == 100 {
                        memoLineLimit = 1
                    } else {
                        memoLineLimit = 100
                    }
                } label: {
                    Label(memoLineLimit != 100 ? "MEMO表示" : "戻す", systemImage: "doc.plaintext")
                }
            }
        } label: {
            
            
            
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
                            .frame(width: 2, height: memoLineLimit != 100 ? 20 : .infinity)
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
                            
                            Spacer()
                        }
                        
                        // MARK: - MEMO：メモ
                        if !poop.wrappedMemo.isEmpty {
                            Text(poop.wrappedMemo)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.exText)
                                .lineLimit(memoLineLimit)
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

//#Preview {
//    TheDayDetailPoopRowView()
//}
