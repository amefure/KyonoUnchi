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
    @State private var showSelectEntryMode = false
    // MARK: - ViewModel
    
    @StateObject private var viewModel = SettingViewModel()
    
    // MARK: - View
    
    @State private var isLock: Bool = false
    
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
                    Text("設定")
                }
            )
            
            List {
                
                Section(header: Text(L10n.settingSectionCalendarTitle)) {
                    
                    HStack {
                        Image(systemName: "calendar")
                        
                        Button {
                            showSelectInitWeek = true
                        } label: {
                            Text(L10n.settingSectionCalendarInitWeek)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.gray)
                        
                    }.sheet(isPresented: $showSelectInitWeek, content: {
                        SelectInitWeek()
                    })
                    
                }
                
                Section(header: Text(L10n.settingSectionAppTitle),
                        footer: Text(L10n.settingSectionAppDesc)) {
                    
                    
                    HStack {
                        Image(systemName: "plus.app")
                        
                        Button {
                            showSelectEntryMode = true
                        } label: {
                            Text(L10n.settingSectionAppEntryMode)
                        }.sheet(isPresented: $showSelectEntryMode, content: {
                            SelectEntryMode()
                        })
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(.gray)
                    }
                    
                    
                    
                    HStack {
                        Image(systemName: "lock.app.dashed")
                        
                        Toggle(isOn: $isLock) {
                            Text(L10n.settingSectionAppLock)
                        }.onChange(of: isLock) { oldValue, newValue in
                            if newValue {
                                viewModel.showPassInput()
                            } else {
                                viewModel.deletePassword()
                            }
                        }.tint(.exPositive)
                    }
                }
                
                Section(header: Text("Link"), footer: Text(L10n.settingSectionLinkDesc)) {
                    //                    if let url = URL(string: UrlLinkConfig.APP_REVIEW_URL) {
                    //                        // 1:レビューページ
                    //                        Link(destination: url, label: {
                    //                            HStack {
                    //                                Image(systemName: "hand.thumbsup")
                    //                                Text(L10n.settingSectionLinkReview)
                    //                            }
                    //                        }).listRowBackground(rootEnvironment.appColor.color)
                    //                            .foregroundStyle(.white)
                    //                    }
                    
                    // 2:シェアボタン
                    //                    Button(action: {
                    //                        viewModel.shareApp(
                    //                            shareText: "",
                    //                            shareLink: ""
                    //                        )
                    //                    }) {
                    //                        HStack {
                    //                            Image(systemName: "star.bubble")
                    //
                    //                            Text(L10n.settingSectionLinkRecommend)
                    //                        }
                    //                    }.listRowBackground(rootEnvironment.appColor.color)
                    //                        .foregroundStyle(.white)
                    
                    if let url = URL(string: UrlLinkConfig.APP_CONTACT_URL) {
                        // 3:お問い合わせフォーム
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "paperplane")
                                Text(L10n.settingSectionLinkContact)
                                Image(systemName: "link").font(.caption)
                            }
                        })
                    }
                    
                    if let url = URL(string: UrlLinkConfig.APP_TERMS_OF_SERVICE_URL) {
                        // 4:利用規約とプライバシーポリシー
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "note.text")
                                Text(L10n.settingSectionLinkTerms)
                                Image(systemName: "link").font(.caption)
                            }
                        })
                    }
                }
            }
        }.foregroundStyle(.exText)
            .onAppear {
                viewModel.onAppear()
                isLock = viewModel.isLock
            }.sheet(isPresented: $viewModel.isShowPassInput, content: {
                AppLockInputView(isLock: $isLock)
            }).navigationBarBackButtonHidden()
    }
}

#Preview {
    SettingView()
}
