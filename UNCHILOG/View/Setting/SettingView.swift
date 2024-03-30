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
    
    // MARK: - ViewModel

    @StateObject private var viewModel = SettingViewModel()

    // MARK: - View

    @State private var isLock: Bool = false
    
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
                    
                
            
                    HStack {
                        Image(systemName: "lock.iphone")
                        
                        Toggle(isOn: $isLock) {
                            Text(L10n.settingSectionAppLock)
                        }.onChange(of: isLock) { newValue in
                            if newValue {
                                viewModel.showPassInput()
                            } else {
                                viewModel.deletePassword()
                            }
                        }.tint(.exPositive)
                    }
                }// .listRowBackground(rootEnvironment.appColor.color)
                
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
        }.onAppear {
            isLock = viewModel.isLock
        }.sheet(isPresented: $viewModel.isShowPassInput, content: {
            AppLockInputView(isLock: $isLock)
       })
    }
}

#Preview {
    SettingView()
}
