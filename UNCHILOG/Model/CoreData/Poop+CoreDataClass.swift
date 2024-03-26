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


}


extension Poop {
    /// デモプレビュー用インスタンス生成メソッド
    static func new(name: String, color: String, order: Int) -> Poop {
        let entity: Poop = CoreDataRepository.entity()
        entity.id = UUID()

        return entity
    }
}
