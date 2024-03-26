//
//  ContentView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = SCCalenderViewModel.shared
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    
    @State var scdate: [SCDate] = []
    var body: some View {
        
        VStack {
            
            NavigationLink {
                PoopInputView()
            } label: {
                Text("Input")
            }
    
            PoopCalendarView()
         
        }.onAppear {
            poopViewModel.fetchAllPoops()
        }
    }
}






#Preview {
    ContentView()
}
