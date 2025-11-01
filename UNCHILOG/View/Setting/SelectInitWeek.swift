//
//  SelectInitWeek.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI

struct SelectInitWeek: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    @State private var selectWeek: SCWeek = .sunday
    @State private var showSuccessAlert = false
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack {
            Text("カレンダーの週の始まりの曜日を変更することができます。")
                .foregroundStyle(.exText)
                .padding(.top, 10)
                .font(.caption)
            
            List {
                ForEach(SCWeek.allCases, id: \.self) { week in
                    Button {
                        selectWeek = week
                    } label: {
                        HStack {
                            Text(week.fullSymbols)
                            
                            Spacer()

                            if selectWeek == week {
                                Image(systemName: "checkmark")
                            }
                        }
                    }.listRowBackground(Color.exFoundation)
                }.foregroundStyle(.exText)
            }.scrollContentBackground(.hidden)
                .background(.white)
            
            Button {
                rootEnvironment.saveInitWeek(week: selectWeek)
                rootEnvironment.setFirstWeek(week: selectWeek)
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
            
        }.foregroundStyle(.exText)
            .fontM(bold: true)
            .alert(
                isPresented: $showSuccessAlert,
                title: L10n.dialogTitle,
                message: L10n.dialogUpdateInitWeek(selectWeek.fullSymbols),
                positiveButtonTitle: L10n.dialogButtonOk,
                positiveAction: { dismiss() }
            ).onAppear {
                selectWeek = rootEnvironment.initWeek
            }.toolbarBackground(.exFoundation, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
                .navigationTitle("週始まり変更")
    }
}

#Preview {
    SelectInitWeek()
}
