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
                .frame(width: 65, height: 65)
            
            Spacer()
            
            ZStack {
                RoundChatView()
                    .fill(Color.white)
                    .frame(width: DeviceSizeUtility.deviceWidth - 120, height: 50)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                Text(msg)
                    .frame(width: DeviceSizeUtility.deviceWidth - 140, height: 50)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                    .offset(x: 10)
            }
            
        }.padding(.vertical, DeviceSizeUtility.isSESize ? 8 : 20)
            .padding(.horizontal, 20)
    }
}

#Preview {
    MrPoopMessageView(msg: "Hello")
}
