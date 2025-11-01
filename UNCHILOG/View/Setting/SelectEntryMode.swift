//
//  SelectEntryMode.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/05.
//

import SwiftUI

struct SelectEntryMode: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    @State private var selectMode: EntryMode = .detail
    
    @State private var showSuccessAlert = false
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    
    init() {
        let appearance = UISegmentedControl.appearance()
        let font = UIFont.boldSystemFont(ofSize: 12)
        appearance.selectedSegmentTintColor = .exText.withAlphaComponent(0.75)
        appearance.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.black], for: .normal)
        appearance.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        
        VStack {
            
            Text("うんちの記録を登録するモードを変更することができます。")
                .foregroundStyle(.exText)
                .padding(.top, 10)
                .font(.caption)
            
            Picker(selection: $selectMode) {
                Text(EntryMode.simple.name).tag(EntryMode.simple)
                Text(EntryMode.detail.name).tag(EntryMode.detail)
            } label: {
                Text("EntryMode")
            }.pickerStyle(SegmentedPickerStyle())
                .frame(width: 300)
            
            switch selectMode {
            case .simple:
                Text("「シンプルモード」に設定するとカレンダー画面の登録ボタン(赤枠)を押下した際に現在時刻でうんちの記録が登録されます。\n登録の際に細かい設定はできませんが、登録後から編集することは可能になっているので詳細モードと同じ内容を追記することが可能です。")
                    .frame(height: 130)
                    .padding(.horizontal, 25)
                    
                
                Image("ss_simple_mode")
                    .resizable()
                    .scaledToFit()
                    .frame(height: DeviceSizeUtility.deviceHeight / 2.3)
            case .detail:
                Text("「詳細モード」に設定するとカレンダー画面の登録ボタンを押下した際に以下の登録画面が表示され、うんちの色、形、量、MEMOなどを入力することが可能です。")
                    .frame(height: 130)
                    .padding(.horizontal, 25)
                    
                    
                Image("ss_detail_mode")
                    .resizable()
                    .scaledToFit()
                    .frame(height: DeviceSizeUtility.deviceHeight / 2.3)
            }
            
            
            Button {
                rootEnvironment.saveEntryMode(mode: selectMode)
                showSuccessAlert = true
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
            
            Spacer()
        }.foregroundStyle(.exText)
            .fontM(bold: true)
            .alert(
                isPresented: $showSuccessAlert,
                title: L10n.dialogTitle,
                message: L10n.dialogUpdateEntryMode(selectMode.name),
                positiveButtonTitle: L10n.dialogButtonOk,
                positiveAction: { dismiss() }
            ).onAppear {
                selectMode = rootEnvironment.entryMode
            }.toolbarBackground(.exFoundation, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
                .navigationTitle("登録モード変更")
    }
}

#Preview {
    SelectEntryMode()
}
