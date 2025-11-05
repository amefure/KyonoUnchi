//
//  TheDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI
import SCCalendar

struct TheDayView: View {
    
    let viewModel: CalendarViewModel
    @Environment(\.rootEnvironment) private var rootEnvironment
    public let theDay: SCDate
    
    @State private var isShowDetailView: Bool = false
    
    private var poopIconWidth: CGFloat {
        DeviceSizeUtility.deviceWidth / 7
    }

    var body: some View {
        VStack {
            if theDay.day == -1 {
                Color.gray
                    .opacity(0.2)
            } else {
                VStack(spacing: 0) {
                    Text("\(theDay.day)")
                        .frame(width: 25, height: 25)
                        .background(theDay.isToday ? Color.exSub : Color.clear)
                        .font(.system(size: DeviceSizeUtility.isSESize ? 14 : 18))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .foregroundStyle(theDay.isToday ? Color.white : theDay.dayColor())
                        .padding(.top, 3)
                        
                    Spacer()
                    
                    if theDay.entities.count != 0 {
                        ZStack {
                            Image("noface_poop")
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceSizeUtility.isSESize ? 35 : 40)
                                .offset(y: -5)

                            
                            Text("\(theDay.entities.count)")
                                .font(.system(size: DeviceSizeUtility.isSESize ? 14 : 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    } else {
                        Color.white
                            .frame(height: DeviceSizeUtility.isSESize ? 35 : 40)
                    }
                }.simultaneousGesture(
                    TapGesture()
                        .onEnded({ _ in
                            isShowDetailView = true
                            //rootEnvironment.addCountInterstitial()
                        })
                )
            }
        }
        .frame(maxWidth: .infinity)
        //.frame(height: DeviceSizeUtility.isSESize ? 68 : 80)
        .overlay {
            Rectangle()
                .stroke(.gray, lineWidth: 0.5)
        }.navigationDestination(isPresented: $isShowDetailView) {
            TheDayDetailView(theDay: theDay)
        }
    }
}

#Preview {
    //TheDayView(theDay: SCDate.demo)
}
