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
                ZStack {
                    Text("登")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .rotationEffect(Angle(degrees: -20))
                        .position(x: 40, y: 40)
                        
                    Text("録")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .rotationEffect(Angle(degrees: 20))
                        .position(x: 110, y: 40)
                    
                    Image("smile_poop")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .offset(y: 15)
                }.frame(width: 150, height: 150)
            }.buttonStyle(.borderless)
                    .background(.exThema)
                    .foregroundStyle(.exSub)
                    .clipShape(RoundedRectangle(cornerRadius: DeviceSizeManager.deviceHeight / 2))
            
            Spacer()
        }.alert("うんちを登録しました。", isPresented: $showSuccessDialog) {
            Button("OK") { }
        } message: {
            
        }.alert("うんちの登録に失敗しました。", isPresented: $showFailedDialog) {
            Button("OK") { }
        } message: {
            Text("時間を置いてから再度試してください。")
        }
    }
}

#Preview {
    PoopInputTodayView()
}
