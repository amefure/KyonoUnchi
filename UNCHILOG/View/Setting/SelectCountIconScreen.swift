//
//  SelectCountIconScreen.swift
//  UNCHILOG
//
//  Created by t&a on 2025/11/20.
//

import SwiftUI

struct SelectCountIconScreen: View {
    @Environment(\.rootEnvironment) private var rootEnvironment
    
    @State private var viewModel: SelectCountIconViewModel
    
    init(container: DIContainer = .shared) {
        viewModel = SelectCountIconViewModel(
            userDefaultsRepository: container.resolve(UserDefaultsRepository.self)
        )
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Text("カレンダーの日付に表示される\nうんちの回数アイコンを変更することができます。")
                .foregroundStyle(.exText)
                .padding(.top, 10)
                .fontS()
            
            List {
                ForEach(CountIconItem.allCases, id: \.self) { icon in
                    Button {
                        viewModel.setCountIcon(icon: icon)
                    } label: {
                        HStack {
                            
                            CountIconView(countIcon: icon)
                            
                            Text(icon.name)
                            
                            Spacer()

                            if viewModel.state.selectCountIcon == icon {
                                Image(systemName: "checkmark")
                            }
                        }
                    }.listRowBackground(Color.exFoundation)
                }.foregroundStyle(.exText)
            }.scrollContentBackground(.hidden)
                .background(.white)
            
            Button {
                viewModel.registerCountIcon()
            } label: {
                Text(L10n.appLockInputEntryButton)
                    .fontWeight(.bold)
                    .padding(10)
                    .frame(width: 100)
                    .background(.exText)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 2))
                            .frame(width: 100)
                            .foregroundStyle(.exText)
                    }.padding(.vertical, 20)
                    .shadow(color: .gray, radius: 3, x: 4, y: 4)
            }
            
        }.foregroundStyle(.exText)
            .fontM(bold: true)
            .alert(
                isPresented: $viewModel.state.isShowSuccessAlert,
                title: L10n.dialogTitle,
                message: L10n.dialogUpdateCountIcon(viewModel.state.selectCountIcon.name),
                positiveButtonTitle: L10n.dialogButtonOk,
                positiveAction: { dismiss() }
            ).onAppear {
                viewModel.onAppear()
            }.onDisappear {
                rootEnvironment.getCountIcon()
            }
            .toolbarBackground(.exFoundation, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
                .navigationTitle("回数アイコン変更")
    }
}

#Preview {
    SelectCountIconScreen()
}


struct CountIconView: View {
    
    let countIcon: CountIconItem
    
    private var iconSize: CGFloat {
        DeviceSizeUtility.isSESize ? 25 : 40
    }
    
    var body: some View {
        switch countIcon {
        case .simple:
            Color.exPoopYellow
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: 60))
        case .simpleDark:
            Color.exThema
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: 60))
        case .simpleBlack:
            Color.exText
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: 60))
        case .poop:
            Image("noface_poop")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .offset(y: -5)
        }
    }
}
