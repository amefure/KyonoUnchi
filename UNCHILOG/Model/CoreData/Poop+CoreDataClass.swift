//
//  Poop+CoreDataClass.swift
//  
//
//  Created by t&a on 2024/03/25.
//
//

import Foundation
import CoreData

@objc(Poop)
public class Poop: NSManagedObject {
    // 値がnilの場合のデフォルト値定義
    public var wrappedId: UUID { id ?? UUID() }
    public var wrappedColor: String { color ?? PoopColor.undefined.rawValue }
    public var wrappedShape: Int { Int(shape) }
    public var wrappedVolume: Int { Int(volume) }
    public var wrappedMemo: String { memo ?? "" }
    public var wrappedCreatedAt: Date { createdAt ?? Date() }
}


extension Poop {
    /// 年月日取得
    public func getDate(format: String = "yyyy-M-d") -> String {
        let str = DateFormatUtility(format: format).getString(date: wrappedCreatedAt)
        return str
    }
    
    /// 時間取得
    public func getTime(format: String = "HH:mm:ss") -> String {
        let str = DateFormatUtility(format: format).getString(date: wrappedCreatedAt)
        return str
    }
}


extension Poop {
    /// デモプレビュー用インスタンス生成メソッド
    static func new(name: String, color: String, order: Int) -> Poop {
        let entity: Poop = CoreDataRepository.entity()
        entity.id = UUID()
        return entity
    }
}
