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
            
            Button {
                rootEnvironment.moveToDayCalendar()
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
            }
            
            Spacer()
            
            NavigationLink {
                PoopInputView(theDay: Date())
            } label: {
                Text("Input")
            }.frame(width: 80, height: 80)
                .background(.exThema)
                .clipShape(RoundedRectangle(cornerRadius: 80))
                .overlay{
                    RoundedRectangle(cornerRadius: 80)
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(.white)
                        .shadow(color: .gray, radius: 3, x: 2, y: 3)
                }.offset(y: -20)
           
            
            Spacer()
            
            Button {
                selectedTab = 0
            } label: {
                
                Image(systemName: "calendar")
            }
            
            Spacer()
            
            
            Button {
                selectedTab = 2
            } label: {
                Image(systemName: "gearshape.fill")
            }
            
            Spacer()
        }.frame(height: 50)
            .background(.exThema)
    }
}

#Preview {
    FooterView(selectedTab: Binding.constant(0))
}
