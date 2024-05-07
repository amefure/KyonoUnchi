//
//  RootView.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/03.
//

import SwiftUI

struct RootView: View {

    
    // MARK: - View
    @State private var selectPage: Int = 0
    
    var body: some View {
        NavigationStack {
            
            TabView(selection: $selectPage) {
                PoopInputTodayView()
                    .tag(0)
                PoopWeekListView()
                    .tag(1)
            }.tabViewStyle(.carousel)
            
            Spacer()
            
        }.ignoresSafeArea(edges: [.bottom])
    }
}

#Preview {
    RootView()
}
