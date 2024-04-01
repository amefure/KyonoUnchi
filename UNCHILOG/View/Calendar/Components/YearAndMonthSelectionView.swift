//
//  YearAndMonthSelectionView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/30.
//

import SwiftUI

struct YearAndMonthSelectionView: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    var body: some View {
        
        HStack {
            Button {
                rootEnvironment.backMonth()
            } label: {
                Image(systemName: "chevron.backward")
            }.padding(.leading, 20)
            
            Spacer()
            
            Text(rootEnvironment.currentYearAndMonth?.yearAndMonth ?? "")
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                rootEnvironment.forwardMonth()
            } label: {
                Image(systemName: "chevron.forward")
            }.padding(.trailing, 20)
                
        }.padding()
            .foregroundStyle(.indigo)
            .background(.exThema)
    }
}

#Preview {
    YearAndMonthSelectionView()
}
