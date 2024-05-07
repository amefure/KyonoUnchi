//
//  iOSConnectRepository.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import Combine
import WatchConnectivity

class iOSConnectRepository: NSObject {
    
    static let shared = iOSConnectRepository()
    
    private var session: WCSession = .default
    
    /// iOSから1週間の取得したPoopリスト
    public var poopList: AnyPublisher<[Poop], SessionDataError> {
        _poopList.eraseToAnyPublisher()
    }
    private let _poopList = PassthroughSubject<[Poop], SessionDataError>()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    // iOS側のデータ要求(transferUserInfoならキューとして貯まる)
    // transferUserInfoはシミュレーターでは動作しないので注意
    public func requestRegisterPoop() -> Bool {
        WatchLogger.debug(items: session.isReachable)
        guard session.isReachable == true else { return false }
        let requestDic: [String: Date] = [CommunicationKey.W_REQUEST_REGISTER_POOP: Date()]
        // self.session.transferUserInfo(requestDic)
        self.session.sendMessage(requestDic, replyHandler: { _ in })
        return true
    }
}


extension iOSConnectRepository: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            WatchLogger.debug(items: error.localizedDescription)
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
        savePoopList(message)
    }
    
    /// transferUserInfoメソッドで送信されたデータを受け取るデリゲートメソッド(バックグラウンドでもキューとして残る)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        savePoopList(userInfo)
    }
    
    private func savePoopList(_ dic: [String : Any]) {
        WatchLogger.debug(items: "データ受信：\(dic)")
        // iOSからデータを取得
        guard let json = dic[CommunicationKey.I_SEND_SCDATE] as? String else {
            _poopList.send(completion: .failure(.notExistHeader))
            return
        }
        // JSONデータをString型→Data型に変換
        guard let jsonData = String(json).data(using: .utf8) else {
            _poopList.send(completion: .failure(.jsonConversionFailed))
            return
        }
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey(rawValue: "managedObjectContext")!] = CoreDataRepository.context
        // JSONデータを構造体に準拠した形式に変換
        if let lives = try? decoder.decode([Poop].self, from: jsonData) {
            // この時点で保存される
            CoreDataRepository.save()
            _poopList.send(lives)
        } else {
            _poopList.send(completion: .failure(.jsonConversionFailed))
        }
    }
}

