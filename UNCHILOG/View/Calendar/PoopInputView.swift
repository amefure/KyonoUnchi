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
    
    @State private var color: PoopColor = .brown
    @State private var shape: PoopShape = .normal
    @State private var volume: PoopVolume = .medium
    @State private var volumeNum: Float = 3
    @State private var hardness: PoopHardness = .medium
    @State private var hardnessNum: Float = 3
    @State private var memo: String = ""
    @State private var createdAt: Date = Date()
    
    @FocusState var isActive: Bool
    @State private var showSuccessAlert: Bool = false
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            HeaderView(
                trailingIcon: "checkmark",
                trailingAction: {
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
                    showSuccessAlert = true
                },
                content: {
                    Text("うんち登録")
                }
            )
            
            ScrollView {
                
                
                InputItemTitleView(title: "時間", subTitle: "Time")
                
                DatePicker("createdAt",
                           selection: $createdAt,
                           displayedComponents: [.hourAndMinute]
                ).frame(width: 300)
                    .labelsHidden()
                
                InputItemTitleView(title: "色", subTitle: "Color")
                
                
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(PoopColor.allCases, id: \.self) { poopColor in
                            if poopColor != .undefined {
                                Button {
                                    color = poopColor
                                } label: {
                                    poopColor.color
                                        .frame(width: 30, height: 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(color == poopColor ? .exGray : .clear, lineWidth: 4)
                                        }
                                }
                            }
                        }
                    }.padding(.vertical)
                }.padding(.horizontal)
                
                InputItemTitleView(title: "形", subTitle: "Shape")
                
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(PoopShape.allCases, id: \.self) { poopShape in
                            if poopShape != .undefined {
                                Button {
                                    shape = poopShape
                                } label: {
                                    poopShape.image
                                }
                            }
                        }
                    }.padding(.vertical)
                }.padding(.horizontal)
                
                
                InputItemTitleView(title: "量", subTitle: "Volume")
                
                Text(volume.name)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                    .opacity(0.8)
                
                Slider(value: $volumeNum, in: 1...Float(PoopVolume.allCases.count - 1), step: 1.0)
                    .onChange(of: volumeNum) { oldValue, newValue in
                        volume = PoopVolume(rawValue: Int(newValue)) ?? .medium
                    }.padding(.horizontal)
                    .tint(.exSub)
                
                
                InputItemTitleView(title: "硬さ", subTitle: "Hardness")
                
                Text(hardness.name)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                    .opacity(0.8)
                
                Slider(value: $hardnessNum, in: 1...Float(PoopHardness.allCases.count - 1), step: 1.0)
                    .onChange(of: hardnessNum) { oldValue, newValue in
                        hardness = PoopHardness(rawValue: Int(newValue)) ?? .medium
                    }.padding(.horizontal)
                    .tint(.exSub)
                
                InputItemTitleView(title: "メモ", subTitle: "MEMO")
                
                TextEditor(text: $memo)
                    .frame(height: 200)
                    .scrollContentBackground(.hidden)
                    .padding(5)
                    .overlay {
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundStyle(.exGray)
                    }
                    .padding(.horizontal)
                    .focused($isActive)
                
            }.padding(.bottom)
            
        }.onTapGesture(perform: {
            isActive = false
        })
        .onAppear {
            if let poop = poop {
                color = PoopColor(rawValue: poop.wrappedColor) ?? .brown
                shape = PoopShape(rawValue: poop.wrappedShape) ?? .normal
                volume = PoopVolume(rawValue: poop.wrappedVolume) ?? .medium
                volumeNum = Float(volume.rawValue)
                hardness = PoopHardness(rawValue: poop.wrappedHardness) ?? .medium
                hardnessNum = Float(hardness.rawValue)
                memo = poop.wrappedMemo
                createdAt = poop.wrappedCreatedAt
            }
            // 現在時間を格納した
            createdAt = df.combineDateWithCurrentTime(theDay: theDay ?? Date())
        }.dialog(
            isPresented: $showSuccessAlert,
            title: L10n.dialogTitle,
            message: poop == nil ? L10n.dialogEntryPoop : L10n.dialogUpdatePoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: {
                dismiss()
            }
        )
    }
}


struct InputItemTitleView: View {
    public var title: String
    public var subTitle: String
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                HStack {
                    Text(title)
                        .foregroundStyle(.exText)
                        .fontWeight(.bold)
                        .opacity(0.8)
                    Spacer()
                }.frame(width: 40)
                
                Text(subTitle)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                    .opacity(0.3)
                    .font(.caption)
                
                Spacer()
            }.padding(.leading, 10)
            
            Divider()
            
        }.padding()
    }
}

#Preview {
    PoopInputView(theDay: Date())
}
