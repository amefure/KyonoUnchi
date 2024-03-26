//
//  CoreDataRepository.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import UIKit
import CoreData

class CoreDataRepository {
    
    /// ファイル名
    private static let persistentName = "UNCHILOG"
    
    ///
    private static var persistenceController: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataRepository.persistentName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    private static var context: NSManagedObjectContext {
        return CoreDataRepository.persistenceController.viewContext
    }
}


extension CoreDataRepository {
    
    /// 新規作成
    static func entity<T: NSManagedObject>() -> T {
        let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: T.self), in: context)!
        return T(entity: entityDescription, insertInto: nil)
    }
    
    /// 取得処理
    static func fetchSingle<T: NSManagedObject>(predicate: NSPredicate? = nil, sorts: [NSSortDescriptor]? = nil) -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        // フィルタリング
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        // ソート
        if let sorts = sorts {
            fetchRequest.sortDescriptors = sorts
        }
        
        do {
            let entitys = try CoreDataRepository.context.fetch(fetchRequest)
            if let entity = entitys.first {
                return entity
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        return nil
    }
    
    /// 取得処理
    static func fetch<T: NSManagedObject>(predicate: NSPredicate? = nil, sorts: [NSSortDescriptor]? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        // フィルタリング
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        // ソート
        if let sorts = sorts {
            fetchRequest.sortDescriptors = sorts
        }
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    
    /// 追加処理
    static func insert(_ object: NSManagedObject) {
        context.insert(object)
    }
    
    /// 削除処理
    static func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    /// 保存処理
    static func save() {
        // 変更がある場合のみ
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

