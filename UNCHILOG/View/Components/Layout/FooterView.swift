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
            NavigationLink {
                PoopInputView(theDay: Date())
            } label: {
                Text("Input")
            }

            
            Button {
                rootEnvironment.moveToDayCalendar()
            } label: {
                Text("MOVE")
            }
            
            
            Button {
                selectedTab = 2
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }.background(.exThema)
    }
}

#Preview {
    FooterView(selectedTab: Binding.constant(0))
}
