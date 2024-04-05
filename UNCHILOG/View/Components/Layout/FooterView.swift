//
//  FooterView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI

struct FooterView: View {
    
    public var date = Date()
    
    // MARK: - ViewModel
    @ObservedObject private var viewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @State private var showInputPoopView = false
    
    var body: some View {
        HStack {

            Spacer()
            
            ZStack {
                
                Color.exThema
                    .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 200))
                        .offset(y: 50)
                
                Button {
                    if rootEnvironment.entryMode == .simple {
                        viewModel.addPoop(createdAt: date)
                        rootEnvironment.showSimpleEntryDialog = true
                    } else {
                        showInputPoopView = true
                    }
                    
                } label: {
                    Text("登録")
                        .offset(y: -10)
                }
            }
            
            Spacer()
        }.frame(height: 50)
            .font(.system(size: 25))
            .background(.exThema)
            .foregroundStyle(.exSub)
            .sheet(isPresented: $showInputPoopView) {
                PoopInputView(theDay: date)
            }
    }
}

#Preview {
    FooterView()
}
