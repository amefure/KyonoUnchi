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
    @State private var viewModel = DIContainer.shared.resolve(PoopInputViewModel.self)
    
    public var theDay: Date?
    public var poopId: UUID?
    
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
                    viewModel.createOrUpdatePoop()
                    showSuccessAlert = true
                },
                content: {
                    Text(viewModel.state.targetPoop == nil
                         ? "うんち登録：\(df.getString(date: viewModel.state.createdAt))"
                         : "うんち記録編集：\(df.getString(date: viewModel.state.createdAt))")
                }
            )
            
            ScrollView {
                
                
                InputItemTitleView(title: "時間", subTitle: "Time")
                
                DatePicker(
                    "createdAt",
                    selection: $viewModel.state.createdAt,
                    displayedComponents: [.hourAndMinute]
                ).frame(width: 300)
                    .labelsHidden()
                
                InputItemTitleView(title: "色", subTitle: "Color")
                
                
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(PoopColor.allCases, id: \.self) { poopColor in
                            if poopColor != .undefined {
                                
                                Button {
                                    viewModel.state.color = poopColor
                                } label: {
                                    VStack {
                                        if viewModel.state.color == poopColor {
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
                                    viewModel.state.shape = poopShape
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
                                            .background(viewModel.state.shape == poopShape ? .exGray : .clear)
                                            .clipShape(RoundedRectangle(cornerRadius: 60))
                                    }
                                }
                            }
                        }
                    }.padding(.vertical)
                }.padding(.horizontal)
                
                
                InputItemTitleView(title: "量", subTitle: "Volume")
                
                Text(viewModel.state.volume.name)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                    .opacity(0.8)
                
                Slider(value: $viewModel.state.volumeNum, in: 1...Float(PoopVolume.allCases.count - 1), step: 1.0)
                    .onChange(of: viewModel.state.volumeNum) { _, newValue in
                        viewModel.state.volume = PoopVolume(rawValue: Int(newValue)) ?? .medium
                    }.padding(.horizontal)
                    .tint(.exSub)
                
                InputItemTitleView(title: "メモ", subTitle: "MEMO")
                
                TextEditor(text: $viewModel.state.memo)
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
            viewModel.onAppear(poopId: poopId, theDay: theDay)
        }.alert(
            isPresented: $showSuccessAlert,
            title: L10n.dialogTitle,
            message: viewModel.state.targetPoop == nil ? L10n.dialogEntryPoop : L10n.dialogUpdatePoop,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: {
                dismiss()
            }
        )
    }
}


private struct InputItemTitleView: View {
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
