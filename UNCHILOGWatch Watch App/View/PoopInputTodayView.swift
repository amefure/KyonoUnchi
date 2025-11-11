//
//  PoopInputTodayView.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/04.
//

import SwiftUI

struct PoopInputTodayView: View {
    @State private var showSuccessDialog = false
    @State private var showFailedDialog = false
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    var body: some View {
        VStack {
            Spacer()
            
            Button {
                if rootEnvironment.requestRegisterPoop() {
                    showSuccessDialog = true
                } else {
                    showFailedDialog = true
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .frame(width: 100, height: 100)
                    .overlay {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(.white)
                    }
                    .compositingGroup()
                    .shadow(color: .black, radius: 3, x: 1, y: 1)
            }.buttonStyle(.borderless)
                    .background(.exThema)
                    .foregroundStyle(.exSub)
                    .clipShape(RoundedRectangle(cornerRadius: DeviceSizeManager.deviceHeight / 2))
            
            Spacer()
        }.alert(L10n.dialogEntryPoop, isPresented: $showSuccessDialog) {
            Button(L10n.dialogButtonOk) { }
        } message: {
            
        }.alert(L10n.dialogEntryFailed, isPresented: $showFailedDialog) {
            Button(L10n.dialogButtonOk) { }
        } message: {
            Text(L10n.dialogEntryFailedMessage)
        }
    }
}

#Preview {
    PoopInputTodayView()
}
