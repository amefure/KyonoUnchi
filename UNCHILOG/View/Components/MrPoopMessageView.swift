//
//  MrPoopMessageView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/20.
//

import SwiftUI

struct MrPoopMessageView: View {
    public var msg: String
    var body: some View {
        HStack {
            Image("mr_poop")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            
            Spacer()
            
            ZStack {
                RoundChatView()
                    .fill(Color.white)
                    .frame(width: DeviceSizeManager.deviceWidth - 120, height: 50)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                Text(msg)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                    .offset(x: 10)
            }
            
        }.padding(20)
    }
}

#Preview {
    MrPoopMessageView(msg: "Hello")
}
