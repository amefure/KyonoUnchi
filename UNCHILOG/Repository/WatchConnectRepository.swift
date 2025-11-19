//
//  WatchConnectRepository.swift
//  UNCHILOG
//
//  Created by t&a on 2024/05/07.
//

@preconcurrency
import Combine
import WatchConnectivity

class WatchConnectRepository: NSObject {
    
    private var session: WCSession = .default
    
    /// 登録する日付情報
    public var entryDate: AnyPublisher<Date, Never> {
        _entryDate.eraseToAnyPublisher()
    }
    private let _entryDate = PassthroughSubject<Date, Never>()
    
    /// Poop情報を送信要求フラグ
    public var sendPoopDataFlag: AnyPublisher<Bool, Never> {
        _sendPoopDataFlag.eraseToAnyPublisher()
    }
    private let _sendPoopDataFlag = PassthroughSubject<Bool, Never>()

    /// Errorを外部へ公開する
    public var errorPublisher: AnyPublisher<WatchError, Never> {
        _errorPublisher.eraseToAnyPublisher()
    }
    private let _errorPublisher = PassthroughSubject<WatchError, Never>()
    
    public func isReachable() -> Bool {
        session.isReachable
    }
    
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
            let poopDic: [String: String] = [CommunicationKey.I_SEND_WEEK_POOPS.rawValue: json]
#if DEBUG
        self.session.sendMessage(poopDic, replyHandler: { _ in })
#else
        self.session.transferUserInfo(poopDic)
#endif
        } catch {
            _errorPublisher.send(error as? SessionDataError ?? SessionDataError.unidentified)
        }
    }
}


extension WatchConnectRepository: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            WatchLogger.debug(items: error.localizedDescription)
            _errorPublisher.send(ConnectError.activateFailed)
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
        receiveMessage(message)
    }
    
    /// transferUserInfoメソッドで送信されたデータを受け取るデリゲートメソッド(バックグラウンドでもキューとして残る)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        receiveMessage(userInfo)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
    private func receiveMessage(_ dic:  [String : Any]) {
        
        guard let key = CommunicationKey.checkForKeyValue(dic) else { return }
        
        switch key {
        case .I_SEND_WEEK_POOPS:
            break
        case .W_REQUEST_WEEK_POOPS:
            _sendPoopDataFlag.send(true)
        case .W_REQUEST_REGISTER_POOP:
            guard let date = dic[key.rawValue] as? Date else {
                _errorPublisher.send(SessionDataError.notExistHeader)
                return
            }
            _entryDate.send(date)
        }
    }
}
