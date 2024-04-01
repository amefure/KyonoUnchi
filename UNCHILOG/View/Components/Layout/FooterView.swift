//
//  FooterView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI

struct FooterView: View {
    // MARK: - Binding
    @Binding var selectedTab: Int
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    var body: some View {
        HStack {

            Spacer()
            
            Button {
                selectedTab = 0
            } label: {
                Image(systemName: "chart.xyaxis.line")
            }

            Spacer()
            
            ZStack {
                
                Color.exThema
                    .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 200))
                        .offset(y: 50)
                
                Button {
                    if selectedTab == 1 {
                        rootEnvironment.moveToDayCalendar()
                    } else {
                        selectedTab = 1
                    }
                } label: {
                    Image(systemName: "calendar")
                        .offset(y: -10)
                }
            }
            
            Spacer()
            
            Button {
                selectedTab = 2
            } label: {
                Image(systemName: "gearshape.fill")
            }
            
            Spacer()
        }.frame(height: 50)
            .font(.system(size: 25))
            .background(.exThema)
            .foregroundStyle(.indigo)
    }
}

#Preview {
    FooterView(selectedTab: Binding.constant(0))
}
