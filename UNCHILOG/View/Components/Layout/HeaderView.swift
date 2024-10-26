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
    
    // MARK: - Environment
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
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
                        .font(.system(size: 18))
                        .padding(.leading, 5)
                        .frame(width: 50)
                }.frame(width: 50)
            } else if !trailingIcon.isEmpty {
                Spacer()
                    .frame(width: 50)
            }
            
            Spacer()
            
            content
            
            Spacer()
            
            if !trailingIcon.isEmpty {
                Button {
                    trailingAction()
                } label: {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 18))
                        .padding(.trailing, 5)
                        .frame(width: 50)
                }.frame(width: 50)
                
            } else if !leadingIcon.isEmpty {
                Spacer()
                    .frame(width: 50)
            }
        }.padding(.vertical)
            .foregroundStyle(.exSub)
            .fontWeight(.bold)
            .background(.exThema)
    }
}

// 親から渡されたViewをラップするためのView
struct HeaderContentView: View {
    var body: some View {
        // ここに親から渡されたViewを表示
        Text("Header Content") // 例としてテキストを表示
            .foregroundColor(.white)
            .font(.title)
    }
}


#Preview {
    HeaderView(leadingIcon: "swift", trailingIcon: "iphone", leadingAction: {}, trailingAction: {}, content: {})
}

