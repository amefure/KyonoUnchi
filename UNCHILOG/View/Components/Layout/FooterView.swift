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
    
    private let df = DateFormatUtility()
    
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
                            rootEnvironment.showSimpleEntryDialog = true
                        } else {
                            rootEnvironment.showSimpleEntryDetailDialog = true
                        }
                        
                    } else {
                        showInputPoopView = true
                    }
                    
                } label: {
                    
                    ZStack {
                     
                        Text("と")
                            .font(.system(size: 16))
                            .rotationEffect(Angle(degrees: -40))
                            .position(x: -5, y: 10)
                        Text("う")
                            .font(.system(size: 16))
                            .rotationEffect(Angle(degrees: -20))
                            .position(x: 20, y: -5)
                        
                        Text("ろ")
                            .font(.system(size: 16))
                            .rotationEffect(Angle(degrees: 20))
                            .position(x: 50, y: -5)
                        Text("く")
                            .font(.system(size: 16))
                            .rotationEffect(Angle(degrees: 40))
                            .position(x: 75, y: 10)
                        
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
            createdAt = df.combineDateWithCurrentTime(theDay: date)
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
