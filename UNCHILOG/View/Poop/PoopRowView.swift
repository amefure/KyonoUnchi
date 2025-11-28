//
//  PoopRowView.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/13.
//

import SwiftUI

struct PoopRowView: View {
    
    let poop: Poop
    let editAction: () -> Void
    let deleteAction: () -> Void
    let toggleMemoAction: () -> Void
    let memoDisplayMode: MemoDisplayMode
    
    var body: some View {
        Menu {
            
            Button(role: .none) {
                editAction()
            } label: {
                Label("編集", systemImage: "square.and.pencil")
            }
            
            Button(role: .none) {
                deleteAction()
            } label: {
                Label("削除", systemImage: "trash")
            }
            
            if !poop.wrappedMemo.isEmpty {
                Button(role: .none) {
                    toggleMemoAction()
                } label: {
                    Label(memoDisplayMode == .singleLine ? "MEMO表示" : "戻す", systemImage: "doc.plaintext")
                }
            }
        } label: {
            
            VStack(spacing: 0) {
                
                HStack {
                    Text(poop.getTime(format: "HH:mm"))
                        .fontM(bold: true)
                        .foregroundStyle(.white)
                        .frame(width: 70)
                        .padding(10)
                        .background(.exText)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.vertical, 20)
                    
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
                                .lineLimit(memoDisplayMode.rawValue)
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
   
}
