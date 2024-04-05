//
//  YearAndMonthSelectionView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/30.
//

import SwiftUI

struct YearAndMonthSelectionView: View {
    
    public var showBackButton = false
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @State private var showSetting = false
    
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        HeaderView(
            leadingIcon: showBackButton ? "arrow.backward" : "",
            trailingIcon: "gearshape.fill", 
            leadingAction: {
                if showBackButton {
                    dismiss()
                }
            },
            trailingAction: {
                showSetting = true
            },
            content: {
                Button {
                    rootEnvironment.backMonth()
                } label: {
                    Image(systemName: "chevron.backward")
                }.padding(.leading, 20)
                
                Spacer()
                
                
                Menu {
                    ForEach(rootEnvironment.selectYearAndMonth.reversed()) { yearAndMonth in
                        Button {
                            rootEnvironment.moveToDayCalendar(year: yearAndMonth.year, month: yearAndMonth.month)
                        } label: {
                            Text(yearAndMonth.yearAndMonth)
                        }
                    }
                } label: {
                    Text(rootEnvironment.currentYearAndMonth?.yearAndMonth ?? "")
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                Button {
                    rootEnvironment.forwardMonth()
                } label: {
                    Image(systemName: "chevron.forward")
                }.padding(.trailing, 20)
            }
        ).navigationDestination(isPresented: $showSetting) {
            SettingView()
        }
    }
}

#Preview {
    YearAndMonthSelectionView()
}
