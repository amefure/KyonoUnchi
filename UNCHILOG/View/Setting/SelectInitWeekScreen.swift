//
//  SelectInitWeekScreen.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI
import SCCalendar

struct SelectInitWeekScreen: View {
    @State private var viewModel = DIContainer.shared.resolve(SelectInitWeekViewModel.self)
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
                        viewModel.setWeek(week: week)
                    } label: {
                        HStack {
                            Text(week.fullSymbols)
                            
                            Spacer()

                            if viewModel.state.selectWeek == week {
                                Image(systemName: "checkmark")
                            }
                        }
                    }.listRowBackground(Color.exFoundation)
                }.foregroundStyle(.exText)
            }.scrollContentBackground(.hidden)
                .background(.white)
            
            Button {
                viewModel.registerInitWeek()
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
                message: L10n.dialogUpdateInitWeek(viewModel.state.selectWeek.fullSymbols),
                positiveButtonTitle: L10n.dialogButtonOk,
                positiveAction: { dismiss() }
            ).onAppear {
                viewModel.onAppear()
            }.toolbarBackground(.exFoundation, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
                .navigationTitle("週始まり変更")
    }
}

#Preview {
    SelectInitWeekScreen()
}
