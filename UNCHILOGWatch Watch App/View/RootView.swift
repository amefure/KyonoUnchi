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
            
            if selectPage == 0 {
                PoopInputTodayView()
            } else {
                PoopWeekListView()
            }
            
            Spacer()
            
            // MARK: - ページ選択タブビュー
            FooterView(selectPage: $selectPage)
        }.ignoresSafeArea(edges: [.bottom])
    }
}

#Preview {
    RootView()
}
