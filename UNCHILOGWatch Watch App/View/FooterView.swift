//
//  FooterView.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/03.
//

import SwiftUI

struct FooterView: View {
    
    // MARK: - View
    @Binding var selectPage: Int
    
    var body: some View {
        HStack(spacing: 10){
            
            Button {
                selectPage = 0
            } label: {
                Image(systemName: "plus.app")
                    .padding(10)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(selectPage == 0 ? .exThema : .white)
            }.buttonStyle(.borderless)
        
            Button {
                selectPage = 1
            } label: {
                Image(systemName: "calendar")
                    .padding(10)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(selectPage == 1 ? .exThema : .white)
            }.buttonStyle(.borderless)
        }
    }
}

#Preview {
    FooterView(selectPage: Binding.constant(0))
}

