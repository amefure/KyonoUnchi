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
    
    init() {
        let appearance = UISegmentedControl.appearance()
        let font = UIFont.boldSystemFont(ofSize: 12)
        appearance.selectedSegmentTintColor = .black.withAlphaComponent(0.75)
        appearance.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.black], for: .normal)
        appearance.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        
        VStack {
            Text("登録モード")
                .fontWeight(.bold)
                .foregroundStyle(.exText)
                .padding(.top, 70)
            
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
                .onChange(of: selectMode) { oldValue, newValue in
                    rootEnvironment.saveEntryMode(mode: newValue)
                }
            
            switch selectMode {
            case .simple:
                Text("シンプルモードに設定するとカレンダー画面の登録ボタンを押下した際に現在時刻で記録が登録されます。\n登録の際に細かい設定はできませんが、登録後から編集することは可能なっているので詳細モードと同じ内容を追記することが可能です。")
            case .detail:
                Text("詳細モードに設定するとカレンダー画面の登録ボタンを押下した際に登録画面が表示され、うんちの硬さや色、形、MEMOなどを入力することが可能です。")
            }
            
            Spacer()
        }.onAppear {
            print("----", rootEnvironment.entryMode)
            selectMode = rootEnvironment.entryMode
        }
    }
}

#Preview {
    SelectEntryMode()
}
