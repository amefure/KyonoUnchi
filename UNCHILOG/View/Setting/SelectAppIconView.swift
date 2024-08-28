//
//  SelectAppIconView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/08/28.
//

import SwiftUI

struct SelectAppIconView: View {
    
    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    
    @State private var appIconName = AppIconName.icon1.rawValue
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text("アプリアイコン変更")
                }
            )
            
            Text("アプリアイコンを変更することができます。")
                .foregroundStyle(.exText)
                .padding(.top, 10)
                .font(.caption)
            
            List {
                Button {
                    appIconName = AppIconName.icon1.rawValue
                    UIApplication.shared.setAlternateIconName(appIconName)
                } label: {
                    HStack {
                        Asset.Images.appIconImg1.swiftUIImage
                              .resizable()
                              .scaledToFit()
                              .frame(width: 50)
                              .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("うんちくん")
                            .foregroundStyle(.exText)
                            .fontWeight(.bold)
                        
                        if appIconName == AppIconName.icon1.rawValue {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundStyle(.exText)
                        }
                    }
                    
                }.buttonStyle(PlainButtonStyle())
                
                Button {
                    appIconName = AppIconName.icon2.rawValue
                    UIApplication.shared.setAlternateIconName(appIconName)
                } label: {
                    HStack {
                        Asset.Images.appIconImg2.swiftUIImage
                              .resizable()
                              .scaledToFit()
                              .frame(width: 50)
                              .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("ブロックうんち　イエロー")
                            .foregroundStyle(.exText)
                            .fontWeight(.bold)
                        
                        if appIconName == AppIconName.icon2.rawValue {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundStyle(.exText)
                        }
                    }
                }.buttonStyle(PlainButtonStyle())

                Button {
                    appIconName = AppIconName.icon3.rawValue
                    UIApplication.shared.setAlternateIconName(appIconName)
                } label: {
                    HStack {
                        Asset.Images.appIconImg3.swiftUIImage
                              .resizable()
                              .scaledToFit()
                              .frame(width: 50)
                              .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("ブロックうんち ブラウン")
                            .foregroundStyle(.exText)
                            .fontWeight(.bold)
                        
                        if appIconName == AppIconName.icon3.rawValue {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundStyle(.exText)
                        }
                    }
                }.buttonStyle(PlainButtonStyle())
                Button {
                    appIconName = AppIconName.icon4.rawValue
                    UIApplication.shared.setAlternateIconName(appIconName)
                } label: {
                    HStack {
                        Asset.Images.appIconImg4.swiftUIImage
                              .resizable()
                              .scaledToFit()
                              .frame(width: 50)
                              .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("ブロックうんち ブラウン2")
                            .foregroundStyle(.exText)
                            .fontWeight(.bold)
                        
                        if appIconName == AppIconName.icon4.rawValue {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundStyle(.exText)
                        }
                    }
                }.buttonStyle(PlainButtonStyle())
                Button {
                    appIconName = AppIconName.icon5.rawValue
                    UIApplication.shared.setAlternateIconName(appIconName)
                    rootEnvironment.saveAppIcon(iconName: appIconName)
                } label: {
                    HStack {
                        Asset.Images.appIconImg5.swiftUIImage
                              .resizable()
                              .scaledToFit()
                              .frame(width: 50)
                              .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("ポップUNCHI")
                            .foregroundStyle(.exText)
                            .fontWeight(.bold)
                        
                        if appIconName == AppIconName.icon5.rawValue {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundStyle(.exText)
                        }
                    }
                }.buttonStyle(PlainButtonStyle())
            }
               
            Spacer()
        }.onAppear {
            appIconName = rootEnvironment.getAppIcon()
        }
    }
}

#Preview {
    SelectAppIconView()
}
