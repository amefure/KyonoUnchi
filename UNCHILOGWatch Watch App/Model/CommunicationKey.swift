//
//  CommunicationKey.swift
//  UNCHILOGWatch Watch App
//
//  Created by t&a on 2024/05/07.
//

import UIKit

enum CommunicationKey: String {
    /// 日付情報送信
    case I_SEND_WEEK_POOPS
    
    /// 日付情報要求
    case W_REQUEST_WEEK_POOPS
    
    /// うんち登録要求
    case W_REQUEST_REGISTER_POOP
    
    /// 辞書型の中に存在するキーを返す
    static func checkForKeyValue(_ dic: [String: Any]) -> CommunicationKey? {
        guard let key = dic.keys.first else { return nil }
        switch CommunicationKey(rawValue: key) {
        case .some(let dicKey):
            return dicKey
        case .none:
            return nil
        }
    }
}
