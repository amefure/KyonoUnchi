//
//  PoopRepository.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit

class PoopRepository {
    
    public func fetchAllPoops() -> [Poop] {
        return CoreDataRepository.fetch(sorts: [NSSortDescriptor(keyPath: \Poop.createdAt, ascending: true)])
    }
    
    public func getTheDateCount(date: Date) -> Int {
        // 指定した日付
        let specifiedDate = Calendar(identifier: .gregorian).startOfDay(for: date)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: specifiedDate)!

        let predicate = NSPredicate(format: "createdAt >= %@ AND createdAt < %@", specifiedDate as NSDate, nextDay as NSDate)
        let list: [Poop] = CoreDataRepository.fetch(predicate: predicate)
        return list.count
    }
    
    public func addPoop(
        color: PoopColor = .undefined,
        shape: PoopShape = .undefined,
        volume: PoopVolume = .undefined,
        memo: String = "",
        createdAt: Date
    ) {
        let entity: Poop = CoreDataRepository.entity()
        entity.id = UUID()
        entity.color = color.rawValue
        entity.shape = Int16(shape.rawValue)
        entity.volume = Int16(volume.rawValue)
        entity.memo = memo
        entity.createdAt = createdAt
        CoreDataRepository.insert(entity)
        CoreDataRepository.save()
    }
    
    public func updatePoop(id : UUID, color: PoopColor, shape: PoopShape, volume: PoopVolume, memo: String, createdAt: Date) {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let poop: Poop = CoreDataRepository.fetchSingle(predicate: predicate) else { return }
        poop.color = color.rawValue
        poop.shape = Int16(shape.rawValue)
        poop.volume = Int16(volume.rawValue)
        poop.memo = memo
        poop.createdAt = createdAt
        CoreDataRepository.save()
    }

    public func deletePoop(id : UUID) {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let poop: Poop = CoreDataRepository.fetchSingle(predicate: predicate) else { return }
        CoreDataRepository.delete(poop)
        CoreDataRepository.save()
    }
}
