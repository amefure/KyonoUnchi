//
//  SettingView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.rootEnvironment) private var rootEnvironment
    
    @StateObject private var viewModel: SettingViewModel
    
    init(container: DIContainer = .shared) {
        _viewModel = StateObject(
            wrappedValue: {
                container.resolve(SettingViewModel.self)
            }()
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            List {
                
                Section(
                    header: Text(L10n.settingSectionCalendarTitle)
                ) {
                    
                    NavigationLink {
                        SelectInitWeekScreen()
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                            
                            Text(L10n.settingSectionCalendarInitWeek)
                            
                        }
                    }.listRowBackground(Color.exFoundation)
                    
                }
                
                Section(
                    header: Text(L10n.settingSectionAppTitle),
                    footer: Text(L10n.settingSectionAppDesc)
                ) {
                    
                    NavigationLink {
                        SelectEntryMode()
                    } label: {
                        HStack {
                            Image(systemName: "plus.app")
                            
                            Text(L10n.settingSectionAppEntryMode)
                        }
                    }.listRowBackground(Color.exFoundation)
    
                    // アプリ内課金
                    NavigationLink {
                        InAppPurchaseView()
                    } label: {
                        HStack {
                            Image(systemName: "app.gift.fill")
                            
                            Text(L10n.settingSectionLinkInAppPurchase)
                        }
                    }.listRowBackground(Color.exFoundation)
                    
                    NavigationLink {
                        SelectAppIconView()
                    } label: {
                        HStack {
                            Image(systemName: "app")
                            
                            Text("アプリアイコンを変更する")
                            
                        }
                    }.listRowBackground(Color.exFoundation)
                    
                    
                    HStack {
                        Image(systemName: "lock.app.dashed")
                        
                        Toggle(isOn: $viewModel.isLock) {
                            Text(L10n.settingSectionAppLock)
                        }.tint(.exText)
                    }.listRowBackground(Color.exFoundation)
                }
                
                Section(
                    header: Text("Link"),
                    footer: Text(L10n.settingSectionLinkDesc)
                ) {
                    if let url = URL(string: UrlLinkConfig.APP_REVIEW_URL) {
                        // 1:レビューページ
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "hand.thumbsup")
                                Text(L10n.settingSectionLinkReview)
                            }
                        }).listRowBackground(Color.exFoundation)
                    }
                    
                    // 2:シェアボタン
                    Button(action: {
                        viewModel.shareApp(
                            shareText: "今日のうんちはうんちの記録を管理できるアプリだよ♪",
                            shareLink: UrlLinkConfig.APP_REVIEW_URL
                        )
                    }) {
                        HStack {
                            Image(systemName: "star.bubble")
                            
                            Text(L10n.settingSectionLinkRecommend)
                        }
                    }.listRowBackground(Color.exFoundation)
                    
                    if let url = URL(string: UrlLinkConfig.APP_CONTACT_URL) {
                        // 3:お問い合わせフォーム
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "paperplane")
                                Text(L10n.settingSectionLinkContact)
                                Image(systemName: "link").font(.caption)
                            }
                        }).listRowBackground(Color.exFoundation)
                    }
                    
                    if let url = URL(string: UrlLinkConfig.APP_TERMS_OF_SERVICE_URL) {
                        // 4:利用規約とプライバシーポリシー
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "note.text")
                                Text(L10n.settingSectionLinkTerms)
                                Image(systemName: "link").font(.caption)
                            }
                        }).listRowBackground(Color.exFoundation)
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(.white)
               
            
            if !rootEnvironment.state.removeAds {
                AdMobBannerView()
                    .frame(height: 60)
            }
            
        }.foregroundStyle(.exText)
            .fontM(bold: true)
            .onAppear {
                viewModel.onAppear()
            }.onDisappear {
                viewModel.onDisappear()
            }.sheet(isPresented: $viewModel.state.isShowPassInput) {
                AppLockInputView(isLock: $viewModel.isLock)
            }
            .toolbarBackground(.exFoundation, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // iOS18以降はtoolbarVisibility
            .navigationTitle("設定")
    }
}

#Preview {
    SettingView()
}
