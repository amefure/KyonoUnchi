//
//  AppLockView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI


struct AppLockView: View {
    // MARK: - ViewModel
    @StateObject private var viewModel = AppLockViewModel()

    // MARK: - View
    @State private var password: [String] = []

    // MARK: - Environment
    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some View {
        VStack(spacing: 0) {
            //HeaderView()

            Spacer()

            ZStack {
                DisplayPasswordView(password: password)
                    .onChange(of: password) { newValue in
                        viewModel.passwordLogin(password: newValue) { result in
                            if result {
                                rootEnvironment.unLockAppLock()
                            } else {
                                password.removeAll()
                            }
                        }
                    }

                if viewModel.isShowProgress {
                    ProgressView()
                        .offset(y: 60)
                } else {
                    Button {
                        viewModel.requestBiometricsLogin { result in
                            if result {
                                rootEnvironment.unLockAppLock()
                            }
                        }
                    } label: {
                        VStack {
                            if viewModel.type == .faceID {
                                Image(systemName: "faceid")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(L10n.appLockFaceId)
                            } else if viewModel.type == .touchID {
                                Image(systemName: "touchid")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(L10n.appLockTouchId)
                            }
                        }
                    }.offset(y: 80)
                        .foregroundStyle(.exText)
                }
            }

            Spacer()

            NumberKeyboardView(password: $password, color: .exThema)
                .ignoresSafeArea(.all)
        }.alert(L10n.appLockFailedPassword, isPresented: $viewModel.isShowFailureAlert) {
            Button("OK") {}
        }
        .onAppear { viewModel.onAppear { result in
            rootEnvironment.unLockAppLock()
        }}
        .background(.exThema)
    }
}

struct NumberKeyboardView: View {
    @Binding var password: [String]
    
    public var color: Color = .exText

    private var height: CGFloat {
        DeviceSizeManager.isSESize ? 60 : 80
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                NumberButton(number: "1", password: $password, color: color)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "2", password: $password, color: color)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "3", password: $password, color: color)
            }

            Rectangle()
                .frame(width: DeviceSizeManager.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "4", password: $password, color: color)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "5", password: $password, color: color)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "6", password: $password, color: color)
            }

            Rectangle()
                .frame(width: DeviceSizeManager.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "7", password: $password, color: color)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "8", password: $password, color: color)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "9", password: $password, color: color)
            }

            Rectangle()
                .frame(width: DeviceSizeManager.deviceWidth, height: 1)

            HStack(spacing: 0) {
                NumberButton(number: "-", password: $password, color: color)

                Rectangle()
                    .frame(width: 1, height: height)

                NumberButton(number: "0", password: $password, color: color)

                Rectangle()
                    .frame(width: 1, height: height)

                Button {
                    password = password.dropLast()
                } label: {
                    Image(systemName: "delete.backward")
                        .frame(width: DeviceSizeManager.deviceWidth / 3, height: height)
                        .background(color)
                }
            }
        }.foregroundStyle(.white)
            .fontWeight(.bold)
    }
}

/// 4桁のブラインドパスワードビュー
struct DisplayPasswordView: View {
    let password: [String]

    var body: some View {
        HStack(spacing: 30) {
            Text(password[safe: 0] == nil ? "ー" : "⚫︎")
            Text(password[safe: 1] == nil ? "ー" : "⚫︎")
            Text(password[safe: 2] == nil ? "ー" : "⚫︎")
            Text(password[safe: 3] == nil ? "ー" : "⚫︎")
        }.foregroundStyle(.exText)
            .fontWeight(.bold)
    }
}

/// 数値入力カスタムキーボード
struct NumberButton: View {
    public let number: String
    @Binding var password: [String]
    public var color: Color = .exText

    private var height: CGFloat {
        DeviceSizeManager.isSESize ? 60 : 80
    }

    var body: some View {
        Button {
            if password.count != 4 && number != "-" {
                password.append(number)
            }
        } label: {
            Text(number)
                .frame(width: DeviceSizeManager.deviceWidth / 3, height: height)
                .background(color)
        }
    }
}

#Preview {
    AppLockView()
}
