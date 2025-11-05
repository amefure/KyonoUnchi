//
//  PoopInputView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

// 更新時対象のPoopオブジェクトはViewModelを介してやり取りする
// 値渡しにすると正常に渡せない時がある
struct PoopInputView: View {
    
    private let df = DateFormatUtility(format: "M月d日")
    // MARK: - ViewModel
    @StateObject private var viewModel = PoopViewModel.shared
    @StateObject private var rootEnvironment = RootEnvironment.shared
    
    public var theDay: Date?
    
    @State private var color: PoopColor = .darkBrown
    @State private var shape: PoopShape = .normal
    @State private var volume: PoopVolume = .medium
    @State private var volumeNum: Float = 3
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
                leadingIcon: "chevron.backward",
                trailingIcon: "checkmark",
                leadingAction: {
                    dismiss()
                },
                trailingAction: {
                    isActive = false
                    if let poop = viewModel.selectPoop {
                        viewModel.updatePoop(
                            id: poop.wrappedId,
                            color: color,
                            shape: shape,
                            volume: volume,
                            memo: memo,
                            createdAt: createdAt
                        )
                    } else {
                        viewModel.addPoop(
                            color: color,
                            shape: shape,
                            volume: volume,
                            memo: memo,
                            createdAt: createdAt
                        )
                        //rootEnvironment.addPoopUpdateCalender(createdAt: createdAt)
                        if df.checkInSameDayAs(date: createdAt) {
                            //rootEnvironment.moveTodayCalendar()
                        }
                    }
                    showSuccessAlert = true
                },
                content: {
                    Text(viewModel.selectPoop == nil ? "うんち登録：\(df.getString(date: createdAt))" : "うんち記録編集：\(df.getString(date: createdAt))" )
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
                                    VStack {
                                        if color == poopColor {
                                            Image(systemName: "arrowshape.down.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(.exText)
                                                .frame(height: 20, alignment: .center)
                                        } else {
                                            Spacer()
                                                .frame(height: 20)
                                        }
                                        poopColor.color
                                            .frame(width: 30, height: 30)
                                            .clipShape(RoundedRectangle(cornerRadius: 30))
                                    }
                                }
                            }
                        }
                    }.padding(.vertical)
                        .padding(.horizontal, 10)
                }.padding(.horizontal)
                
                InputItemTitleView(title: "形", subTitle: "Shape")
                
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(PoopShape.allCases, id: \.self) { poopShape in
                            if poopShape != .undefined {
                                Button {
                                    shape = poopShape
                                } label: {
                                    VStack(spacing: 0) {
                                        
                                        Text(poopShape.name)
                                            .font(.caption)
                                            .foregroundStyle(.exText)
                                     
                                        poopShape.image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 55)
                                            .padding(5)
                                            .background(shape == poopShape ? .exGray : .clear)
                                            .clipShape(RoundedRectangle(cornerRadius: 60))
                                    }
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
                    .onChange(of: volumeNum) { _, newValue in
                        volume = PoopVolume(rawValue: Int(newValue)) ?? .medium
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
            if let poop = viewModel.selectPoop {
                color = PoopColor(rawValue: poop.wrappedColor) ?? .brown
                shape = PoopShape(rawValue: poop.wrappedShape) ?? .normal
                volume = PoopVolume(rawValue: poop.wrappedVolume) ?? .medium
                volumeNum = Float(volume.rawValue)
                memo = poop.wrappedMemo
                createdAt = poop.date
                
                // シンプルで登録された場合は自動で初期値を設定しておく
                if color == .undefined {
                    color = .darkBrown
                    shape = .normal
                    volume = .medium
                    volumeNum = Float(volume.rawValue)
                }
                
            } else {
                // 現在時間を格納した該当の日付を生成
                createdAt = df.combineDateWithCurrentTime(theDay: theDay ?? Date())
            }
        }.dialog(
            isPresented: $showSuccessAlert,
            title: L10n.dialogTitle,
            message: viewModel.selectPoop == nil ? L10n.dialogEntryPoop : L10n.dialogUpdatePoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: {
                viewModel.selectPoop = nil
                
               // rootEnvironment.addCountInterstitial()
                
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
                Text(title)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                    .opacity(0.8)
                    .frame(width: 40, alignment: .leading)
                
                Text(subTitle)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                    .opacity(0.3)
                    .font(.system(size: 18))
                
                Spacer()
            }.padding(.leading, 10)
            
            Divider()
            
        }.padding()
    }
}

#Preview {
    PoopInputView(theDay: Date())
}
