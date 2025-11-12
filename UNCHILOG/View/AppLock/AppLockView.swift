//
//  AppLockView.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/28.
//

import SwiftUI


struct AppLockView: View {
    
    @State private var viewModel = DIContainer.shared.resolve(AppLockViewModel.self)
    @State private var password: [String] = []
    @Environment(\.rootEnvironment) private var rootEnvironment

    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            ZStack {
                DisplayPasswordView(password: password)
                    .onChange(of: password) { _, newValue in
                        viewModel.passwordLogin(password: newValue) { result in
                            if result == false {
                                password.removeAll()
                            }
                        }
                    }

                if viewModel.state.isShowProgress {
                    ProgressView()
                        .offset(y: 60)
                } else {
                    Button {
                        Task {
                            await viewModel.requestBiometricsLogin()
                        }
                    } label: {
                        VStack {
                            if viewModel.state.type == .faceID {
                                Image(systemName: "faceid")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(L10n.appLockFaceId)
                            } else if viewModel.state.type == .touchID {
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

            NumberKeyboardView(password: $password)
                .ignoresSafeArea(.all)
        }.alert(
            isPresented: $viewModel.state.isShowFailureAlert,
            title: "Error",
            message: L10n.appLockFailedPassword
        )
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .background(.white)
        .navigationDestination(isPresented: $viewModel.state.isShowApp) {
            RootView()
        }
    }
}

struct NumberKeyboardView: View {
    @Binding var password: [String]
    
    public var color: Color = .exText

    private var height: CGFloat {
        DeviceSizeUtility.isSESize ? 60 : 80
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
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

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
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

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
                .frame(width: DeviceSizeUtility.deviceWidth, height: 1)

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
                        .frame(width: DeviceSizeUtility.deviceWidth / 3, height: height)
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
        DeviceSizeUtility.isSESize ? 60 : 80
    }

    var body: some View {
        Button {
            if password.count != 4 && number != "-" {
                password.append(number)
            }
        } label: {
            Text(number)
                .frame(width: DeviceSizeUtility.deviceWidth / 3, height: height)
                .background(color)
        }
    }
}

#Preview {
    AppLockView()
}
