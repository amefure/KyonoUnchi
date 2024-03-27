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
    public var wrappedHardness: Int { Int(hardness) }
    public var wrappedMemo: String { memo ?? "" }
    public var wrappedCreatedAt: Date { createdAt ?? Date() }
}


extension Poop {
    /// デモプレビュー用インスタンス生成メソッド
    public func getDate() -> String {
        let str = DateFormatManager(format: "yyyy-M-d").getString(date: wrappedCreatedAt)
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
