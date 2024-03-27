//
//  ContentView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    
    var body: some View {
        
        VStack {
            PoopCalendarView()
         
        }.onAppear {
            poopViewModel.fetchAllPoops()
        }
    }
}






#Preview {
    ContentView()
}
