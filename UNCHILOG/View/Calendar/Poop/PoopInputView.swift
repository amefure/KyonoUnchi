//
//  PoopInputView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct PoopInputView: View {
    
    private let df = DateFormatUtility()
    // MARK: - ViewModel
    @ObservedObject private var viewModel = PoopViewModel.shared
    
    public var theDay: Date?
    public var poop: Poop? = nil
    
    @State private var color: PoopColor = .undefined
    @State private var shape: PoopShape = .undefined
    @State private var volume: PoopVolume = .undefined
    @State private var hardness: PoopHardness = .undefined
    @State private var memo: String = ""
    @State private var createdAt: Date = Date()
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            DatePicker("createdAt",
              selection: $createdAt,
              displayedComponents: [.hourAndMinute]
            )
            
            HStack(spacing: 15) {
                ForEach(PoopColor.allCases, id: \.self) { poopColor in
                    Button {
                        color = poopColor
                    } label: {
                        poopColor.color
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .overlay {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(color == poopColor ? Color.white : .clear, lineWidth: 4)
                            }
                    }
                }
            }.padding(.vertical)
            
            HStack(spacing: 15) {
                ForEach(PoopShape.allCases, id: \.self) { poopShape in
                    Button {
                        shape = poopShape
                    } label: {
                        Text("\(poopShape.rawValue)")
                    }
                }
            }.padding(.vertical)
            
            HStack(spacing: 15) {
                ForEach(PoopVolume.allCases, id: \.self) { poopVolume in
                    Button {
                        volume = poopVolume
                    } label: {
                        Text("\(poopVolume.rawValue)")
                    }
                }
            }.padding(.vertical)
            
            HStack(spacing: 15) {
                ForEach(PoopHardness.allCases, id: \.self) { poopHardness in
                    Button {
                        hardness = poopHardness
                    } label: {
                        Text("\(poopHardness.rawValue)")
                    }
                }
            }.padding(.vertical)
            
            TextEditor(text: $memo)
            
            
            Button {
                
                if let poop = poop {
                    viewModel.updatePoop(
                        id: poop.wrappedId,
                        color: color,
                        shape: shape,
                        volume: volume,
                        hardness: hardness,
                        memo: memo
                    )
                } else {
                    viewModel.addPoop(
                        color: color,
                        shape: shape,
                        volume: volume,
                        hardness: hardness,
                        memo: memo,
                        createdAt: createdAt
                    )
                }
                dismiss()
            } label: {
                Text("登録")
            }
            
        }.onAppear {
            if let poop = poop {
                color = PoopColor(rawValue: poop.wrappedColor) ?? .undefined
                shape = PoopShape(rawValue: poop.wrappedShape) ?? .undefined
                volume = PoopVolume(rawValue: poop.wrappedVolume) ?? .undefined
                hardness = PoopHardness(rawValue: poop.wrappedHardness) ?? .undefined
                memo = poop.wrappedMemo
                createdAt = poop.wrappedCreatedAt
            }
            
            // 現在時間を格納した
            createdAt = df.combineDateWithCurrentTime(theDay: theDay ?? Date())
        }
    }
}

#Preview {
    PoopInputView(theDay: Date())
}