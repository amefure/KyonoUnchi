//
//  TheDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI

struct TheDayView: View {
    
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    public let theDay: SCDate
    
    private var poopIconWidth: CGFloat {
        DeviceSizeManager.deviceWidth / 7
    }

    var body: some View {
        VStack {
            if theDay.day == -1 {
                Color.gray
                    .opacity(0.2)
            } else {
                NavigationLink {
                    TheDayDetailView(theDay: theDay)
                } label: {
                    VStack(spacing: 0) {
                        Text("\(theDay.day)")
                            .frame(width: 25, height: 25)
                            .background(theDay.isToday ? Color.exSub : Color.clear)
                            .font(.system(size: DeviceSizeManager.isSESize ? 14 : 18))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .foregroundStyle(theDay.isToday ? Color.white : theDay.dayColor())
                            .padding(.top, 3)
                            
                        Spacer()
                        
                        if theDay.count != 0 {
                            ZStack {
                                Image("noface_poop")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: DeviceSizeManager.isSESize ? 35 : 40)
                                    .offset(y: -5)
    
                                
                                Text("\(theDay.count)")
                                    .font(.system(size: DeviceSizeManager.isSESize ? 14 : 18))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        } else {
                            Spacer()
                                .frame(height: DeviceSizeManager.isSESize ? 35 : 40)
                        }
                    }
                }.simultaneousGesture(
                    TapGesture()
                        .onEnded({ _ in
                            rootEnvironment.addCountInterstitial()
                        })
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: DeviceSizeManager.isSESize ? 68 : 80)
        .overlay {
            Rectangle()
                .stroke(.gray, lineWidth: 0.5)
        }
    }
}

#Preview {
    TheDayView(theDay: SCDate.demo)
}
