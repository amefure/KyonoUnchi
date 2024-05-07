//
//  WatchConnectRepository.swift
//  UNCHILOG
//
//  Created by t&a on 2024/05/07.
//

import Combine
import WatchConnectivity

class WatchConnectRepository: NSObject {
    
    static let shared = WatchConnectRepository()
    
    private var session: WCSession = .default
    
    /// 登録する日付情報
    public var entryDate: AnyPublisher<Date, Never> {
        _entryDate.eraseToAnyPublisher()
    }
    private let _entryDate = PassthroughSubject<Date, Never>()

    /// Errorを外部へ公開する
    public var errorPublisher: AnyPublisher<WatchError, Never> {
        _errorPublisher.eraseToAnyPublisher()
    }
    private let _errorPublisher = PassthroughSubject<WatchError, Never>()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        } else {
            _errorPublisher.send(ConnectError.noSupported)
        }
    }
    
    /// [Poop] をJSON形式に変換する
    private func jsonConverter(poops: [Poop]) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let jsonData = try? encoder.encode(poops) {
            if let json = String(data: jsonData , encoding: .utf8) {
                // 文字コードUTF8のData型に変換
                return json
            }
        }
        // エンコード失敗
        throw SessionDataError.jsonConversionFailed
    }
    
    public func send(_ poops: [Poop]) {
        guard session.isReachable == true else { return }
        do {
            let json = try jsonConverter(poops: poops)
            let poopDic: [String: String] = [CommunicationKey.I_SEND_SCDATE: json]
           // self.session.transferUserInfo(poopDic)
            self.session.sendMessage(poopDic) { _ in }
        } catch {
            _errorPublisher.send(error as? SessionDataError ?? SessionDataError.unidentified)
        }
    }
}


extension WatchConnectRepository: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            WatchLogger.debug(items: error.localizedDescription)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self._errorPublisher.send(ConnectError.activateFailed)
            }
        } else {
            WatchLogger.debug(items: "セッション：アクティベート")
        }
    }
    
    /// iOSアプリ通信可能状態が変化した際に呼ばれる
    func sessionReachabilityDidChange(_ session: WCSession) {
        WatchLogger.debug(items: "通信状態が変化：\(session.isReachable)")
    }
    
    /// sendMessageメソッドで送信されたデータを受け取るデリゲートメソッド(使用されていない)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let date = message[CommunicationKey.W_REQUEST_REGISTER_POOP] as? Date else {
            _errorPublisher.send(SessionDataError.notExistHeader)
            return
        }
        _entryDate.send(date)
    }
    
    /// transferUserInfoメソッドで送信されたデータを受け取るデリゲートメソッド(バックグラウンドでもキューとして残る)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        guard let date = userInfo[CommunicationKey.W_REQUEST_REGISTER_POOP] as? Date else {
            _errorPublisher.send(SessionDataError.notExistHeader)
            return
        }
        _entryDate.send(date)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
}
