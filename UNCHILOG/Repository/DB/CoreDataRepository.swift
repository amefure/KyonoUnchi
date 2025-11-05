//
//  CoreDataRepository.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/25.
//

import UIKit
import CoreData

/// ローカル保存データベースの基底`Repository`クラス
/// `Core Data`のロジックだけを内包
final class CoreDataRepository: Sendable {
    
    /// ファイル名
    private static let persistentName = "UNCHILOG"
    
    ///
    private var persistenceController: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataRepository.persistentName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistenceController.viewContext
    }
    
    private var bgContext: NSManagedObjectContext?
    
    private var getBgContext: NSManagedObjectContext {
        if bgContext == nil {
            bgContext = persistenceController.newBackgroundContext()
            bgContext?.automaticallyMergesChangesFromParent = true
        }
        return bgContext!
    }
}


extension CoreDataRepository {
    
    /// 新規作成
    func entity<T: NSManagedObject>() -> T? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: T.self), in: context) else { return nil }
        return T(entity: entityDescription, insertInto: nil)
    }
    
    /// 取得処理
    func fetchSingle<T: NSManagedObject>(
        predicate: NSPredicate? = nil,
        sorts: [NSSortDescriptor]? = nil
    ) -> T? {
        guard let entity: T = fetch(predicate: predicate, sorts: sorts).first else { return nil }
        return entity
    }
    
    /// 取得処理
    func fetch<T: NSManagedObject>(
        predicate: NSPredicate? = nil,
        sorts: [NSSortDescriptor]? = nil
    ) -> [T] {
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
            AppLogger.logger.error("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    
    /// 追加処理
    func insert(_ object: NSManagedObject) {
        context.insert(object)
    }
    
    /// 削除処理
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    /// 保存処理
    func save() {
        // 変更がある場合のみ
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

