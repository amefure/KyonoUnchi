//
//  SelectAppIconView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/08/28.
//

import SwiftUI

struct SelectAppIconView: View {
    
    @Environment(\.rootEnvironment) private var rootEnvironment
    
    @State private var appIconName = AppIconName.icon1.rawValue
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {

            Text("アプリアイコンを変更することができます。")
                .foregroundStyle(.exText)
                .padding(.top, 10)
                .font(.caption)
            
            List {
                Button {
                    appIconName = AppIconName.icon1.rawValue
                    UIApplication.shared.setAlternateIconName(nil)
                    rootEnvironment.saveAppIcon(iconName: appIconName)
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
                    .listRowBackground(Color.exFoundation)
                
                Button {
                    appIconName = AppIconName.icon2.rawValue
                    UIApplication.shared.setAlternateIconName(appIconName)
                    rootEnvironment.saveAppIcon(iconName: appIconName)
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
                    .listRowBackground(Color.exFoundation)

                Button {
                    appIconName = AppIconName.icon3.rawValue
                    UIApplication.shared.setAlternateIconName(appIconName)
                    rootEnvironment.saveAppIcon(iconName: appIconName)
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
                        }
                    }
                }.buttonStyle(PlainButtonStyle())
                    .listRowBackground(Color.exFoundation)
                
                Button {
                    appIconName = AppIconName.icon4.rawValue
                    UIApplication.shared.setAlternateIconName(appIconName)
                    rootEnvironment.saveAppIcon(iconName: appIconName)
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
                    .listRowBackground(Color.exFoundation)
                
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
                    .listRowBackground(Color.exFoundation)
            }.scrollContentBackground(.hidden)
                .background(.white)
               
            Spacer()
        }.foregroundStyle(.exText)
            .fontM(bold: true)
            .onAppear {
                appIconName = rootEnvironment.getAppIcon()
            }.toolbarBackground(.exFoundation, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
            .navigationTitle("アプリアイコン変更")
    }
}

#Preview {
    SelectAppIconView()
}
