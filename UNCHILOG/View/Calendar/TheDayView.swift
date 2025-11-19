//
//  TheDayView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import SwiftUI
import SCCalendar

struct TheDayView: View {
    
    let theDay: SCDate
    let onTap: (SCDate) -> Void
    
    private var poopIconWidth: CGFloat {
        DeviceSizeUtility.deviceWidth / 7
    }
    
    private var iconSize: CGFloat {
        DeviceSizeUtility.isSESize ? 25 : 40
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
                        .fontS()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .foregroundStyle(theDay.isToday ? Color.white : theDay.dayColor())
                        .padding(.top, 3)
                        
                    Spacer()
                    
                    if theDay.entities.count != 0 {
                        ZStack {
                            Color.exPoopYellow
                            //Image("noface_poop")
                                //.resizable()
                                //.scaledToFit()
                                .frame(width: iconSize, height: iconSize)
                                .clipShape(RoundedRectangle(cornerRadius: 60))
                            
                            Text("\(theDay.entities.count)")
                                .font(.system(size: DeviceSizeUtility.isSESize ? 14 : 18))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                    } else {
                        Color.white
                            .frame(height: iconSize)
                    }
                    Spacer()
                }.onTapGesture {
                    onTap(theDay)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .overlay {
            Rectangle()
                .stroke(.gray, lineWidth: 0.5)
        }
    }
}


#Preview {
    TheDayView(
        theDay: SCDate.demo,
        onTap: { _ in }
    )
}
