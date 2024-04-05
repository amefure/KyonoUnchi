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
    
    
    
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        HStack {
            
            if showBackButton {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.backward")
                })
                    .frame(width: 30)
                
            } else {
                Spacer()
                    .frame(width: 30)
                
            }
            
            Spacer()
            
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
            
            Spacer()
            
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gearshape.fill")
            }.frame(width: 30)
                
        }.padding(.horizontal)
            .padding(.vertical, 10)
            .foregroundStyle(.exSub)
            .background(.exThema)
    }
}

#Preview {
    YearAndMonthSelectionView()
}
