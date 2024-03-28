//
//  SettingView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @State private var showSelectInitWeek = false
    var body: some View {
        VStack {
            List {
                
                Section(header: Text(L10n.settingSectionCalendarTitle),
                        footer: Text(L10n.settingSectionAppDesc)) {
                    
                    HStack {
                        Image(systemName: "calendar")
                        
                        Button {
                            showSelectInitWeek = true
                        } label: {
                            Text(L10n.settingSectionCalendarInitWeek)
                        }
                        
                        Spacer()
                        
                        
                        
                    }.sheet(isPresented: $showSelectInitWeek, content: {
                        SelectInitWeek()
                    })
                    .foregroundStyle(.exText)
                    
                
            
//                    HStack {
//                        Image(systemName: "lock.iphone")
//                        
//                        Toggle(isOn: $isLock) {
//                            Text(L10n.settingSectionAppLock)
//                        }.onChange(of: isLock, perform: { newValue in
//                            if newValue {
//                                viewModel.showPassInput()
//                            } else {
//                                viewModel.deletePassword()
//                            }
//                        }).tint(.exPositive)
//                    }.sheet(isPresented: $viewModel.isShowPassInput, content: {
//                        AppLockInputView(isLock: $isLock)
//                    })
//                    .foregroundStyle(.white)
                }// .listRowBackground(rootEnvironment.appColor.color)
            }
        }
    }
}

#Preview {
    SettingView()
}
