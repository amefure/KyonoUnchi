//
//  ContentView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/24.
//

import SwiftUI

struct RootView: View {
    
    private var dateFormatUtility = DateFormatUtility()
    
    @ObservedObject private var poopViewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    private var calenderViewModel = SCCalenderRepository()
    
    var body: some View {
        
        VStack {
            PoopCalendarView()
            
            HStack {
                
                NavigationLink {
                    PoopInputView(theDay: Date())
                } label: {
                    Text("Input")
                }
        
                
                Button {
                    let today = dateFormatUtility.convertDateComponents(date: rootEnvironment.today)
                    guard let year = today.year,
                          let month = today.month else { return }
                    calenderViewModel.moveYearAndMonthCalendar(year: year, month: month)
                } label: {
                    Text("MOVE")
                }

                
            }
         
        }.dialog(
            isPresented: $rootEnvironment.showOutOfRangeCalendar,
            title: L10n.dialogTitle,
            message: L10n.dialogOutOfRangeCalendar,
            positiveButtonTitle: L10n.dialogButtonOk,
            positiveAction: { rootEnvironment.showOutOfRangeCalendar = false }
        ).onAppear {
            poopViewModel.fetchAllPoops()
        }
    }
}






#Preview {
    RootView()
}
