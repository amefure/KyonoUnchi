//
//  Poop+CoreDataClass.swift
//
//
//  Created by t&a on 2024/03/25.
//
//

import Foundation
import CoreData
import SCCalendar

@objc(Poop)
public class Poop: NSManagedObject, Decodable, Encodable, SCDateEntity {
    // 値がnilの場合のデフォルト値定義
    public var wrappedId: UUID { id ?? UUID() }
    public var wrappedColor: String { color ?? PoopColor.undefined.rawValue }
    public var wrappedShape: Int { Int(shape) }
    public var wrappedVolume: Int { Int(volume) }
    public var wrappedMemo: String { memo ?? "" }
    // public var wrappedCreatedAt: Date { createdAt ?? Date() }
    public var date: Date {
        get {
            createdAt ?? Date()
        }
        set { }
    }
   
    
    enum CodingKeys: CodingKey {
        case id, createdAt
    }
    
    convenience init(id: UUID, createdAt: Date) {
        self.init()
        self.id = id
        self.createdAt = createdAt
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
    }
    
    required public convenience init(from decoder: Decoder) throws {
        // CoreDataをJSONにデコードするにはuserInfoからcontextを取得する
        guard let context = decoder.userInfo[CodingUserInfoKey(rawValue: "managedObjectContext")!] as? NSManagedObjectContext else { fatalError() }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}


extension Poop {
    /// 年月日取得
    public func getDate(format: String = "yyyy-M-d") -> String {
        let str = DateFormatUtility(format: format).getString(date: date)
        return str
    }
    
    /// 時間取得
    public func getTime(format: String = "HH:mm:ss") -> String {
        let str = DateFormatUtility(format: format).getString(date: date)
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

