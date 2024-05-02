//
//  FooterView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI

struct FooterView: View {
    
    public var date = Date()
    public var isRoot = true
    
    private let dateFormatUtility = DateFormatUtility()
    
    // MARK: - ViewModel
    @ObservedObject private var viewModel = PoopViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @State private var showInputPoopView = false
    @State private var createdAt = Date()
    
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
                        viewModel.addPoop(createdAt: createdAt)
                        if isRoot {
                            let (year, month) = dateFormatUtility.getTodayYearAndMonth()
                            rootEnvironment.moveToDayCalendar(year: year, month: month)
                            rootEnvironment.showSimpleEntryDialog = true
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
                        
                        Image("smile_poop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .offset(y: -5)
                    }.frame(width: 70, height: 70)
                }
            }
            
            Spacer()
        }.onAppear {
            // 現在時間を格納した該当の日付を生成
            createdAt = dateFormatUtility.combineDateWithCurrentTime(theDay: date)
        }
        .frame(height: 50)
            .font(.system(size: 25))
            .background(.exThema)
            .foregroundStyle(.exSub)
            .fullScreenCover(isPresented: $showInputPoopView) {
                PoopInputView(theDay: date)
            }
    }
}

#Preview {
    FooterView()
}
