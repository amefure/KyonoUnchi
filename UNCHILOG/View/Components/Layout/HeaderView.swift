//
//  HeaderView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/04/05.
//

import SwiftUI

struct HeaderView<Content: View>: View {
    
    // MARK: - Properties
    let leadingIcon: String
    let trailingIcon: String
    let leadingAction: () -> Void
    let trailingAction: () -> Void
    let isShowLogo: Bool
    let content: Content
    
    private let buttonSize: CGFloat = 40
    
    init(leadingIcon: String = "",
         trailingIcon: String = "",
         leadingAction: @escaping () -> Void = {},
         trailingAction: @escaping () -> Void = {},
         isShowLogo: Bool = true,
         @ViewBuilder content: @escaping () -> Content) {
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
        self.isShowLogo = isShowLogo
        self.content = content()
    }
    
    var body: some View {
        HStack {
            
            if !leadingIcon.isEmpty {
                Button {
                    leadingAction()
                } label: {
                    Image(systemName: leadingIcon)
                        .fontM(bold: true)
                        .frame(width: buttonSize, height: buttonSize)
                        .background(.white.opacity(0.98))
                        .clipShape(RoundedRectangle(cornerRadius: buttonSize))
                }
            } else if !trailingIcon.isEmpty {
                Spacer()
                    .frame(width: buttonSize)
            }
            
            Spacer()
            
            content
            
            Spacer()
            
            if !trailingIcon.isEmpty {
                Button {
                    trailingAction()
                } label: {
                    Image(systemName: trailingIcon)
                        .fontM(bold: true)
                        .frame(width: buttonSize, height: buttonSize)
                        .background(.white.opacity(0.98))
                        .clipShape(RoundedRectangle(cornerRadius: buttonSize))
                }
                
            } else if !leadingIcon.isEmpty {
                Spacer()
                    .frame(width: buttonSize)
            }
        }.padding(.vertical, 10)
            .padding(.horizontal)
            .foregroundStyle(.exThema)
            .fontWeight(.bold)
            .background(.exFoundation)
    }
}


#Preview {
    HeaderView(
        leadingIcon: "swift",
        trailingIcon: "iphone",
        leadingAction: {},
        trailingAction: {},
        content: {}
    )
}

