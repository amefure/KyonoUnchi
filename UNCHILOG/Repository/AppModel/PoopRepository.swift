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
    
    public func addPoop(color: PoopColor, shape: PoopShape, volume: PoopVolume, memo: String, createdAt: Date) {
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
