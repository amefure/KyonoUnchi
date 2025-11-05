//
//  FooterView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI

struct FooterView: View {
    
    public var date: Date? = nil
    public var isRoot = true
    
    private let dateFormatUtility = DateFormatUtility()
    
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
                    if rootEnvironment.state.entryMode == .simple {
                        if let date = date {
                            // 現在時間を格納した該当の日付を生成して登録
                            let createdAt = dateFormatUtility.combineDateWithCurrentTime(theDay: date)
                            viewModel.addPoop(createdAt: createdAt)
                            //rootEnvironment.addPoopUpdateCalender(createdAt: createdAt)
                        } else {
                            // 現在時刻を取得して登録
                            let createdAt = Date()
                            viewModel.addPoop(createdAt: createdAt)
                          //  rootEnvironment.addPoopUpdateCalender(createdAt: createdAt)
                        }
                        
                        if isRoot {
                           // rootEnvironment.moveTodayCalendar()
                            //rootEnvironment.showSimpleEntryDialog = true
                        } else {
                            rootEnvironment.showSimpleEntryDetailDialog = true
                        }
                        
                    } else {
                        showInputPoopView = true
                    }
                } label: {
                    
                    ZStack {
                     
                        Text("登")
                            .font(.system(size: 16))
                            .rotationEffect(Angle(degrees: -20))
                            .position(x: 10, y: 5)
                        Text("録")
                            .font(.system(size: 16))
                            .rotationEffect(Angle(degrees: 20))
                            .position(x: 60, y: 5)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .offset(y: -5)
                    }.frame(width: 70, height: 70)
                }
            }
            
            Spacer()
        }
        .frame(height: 50)
            .font(.system(size: 25))
            .background(.exThema)
            .foregroundStyle(.exSub)
            .fullScreenCover(isPresented: $showInputPoopView) {
                PoopInputView(theDay: date ?? Date())
            }
    }
}

#Preview {
    FooterView()
}
