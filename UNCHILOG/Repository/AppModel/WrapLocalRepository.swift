//
//  WrapLocalRepository.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit

protocol WrapLocalRepositoryProtocol {
    func fetchAllPoops() -> [Poop]
    func getByTheDate(date: Date) -> [Poop]

    func addPoop(
        color: PoopColor,
        shape: PoopShape,
        volume: PoopVolume,
        memo: String,
        createdAt: Date
    )
    
    func addPoopSimple(createdAt: Date)
    
    func updatePoop(
        id : UUID,
        color: PoopColor,
        shape: PoopShape,
        volume: PoopVolume,
        memo: String,
        createdAt: Date
    )
    
    func deletePoop(id : UUID)
}


///
final class WrapLocalRepository: WrapLocalRepositoryProtocol {
    
    private let localRepository: CoreDataRepository
    
    init(localRepository: CoreDataRepository) {
        self.localRepository = localRepository
    }
    
    public func fetchAllPoops() -> [Poop] {
        return localRepository.fetch(
            sorts: [NSSortDescriptor(keyPath: \Poop.createdAt, ascending: true)]
        )
    }
    
    public func getByTheDate(date: Date) -> [Poop] {
        // 指定した日付
        let specifiedDate = Calendar(identifier: .gregorian).startOfDay(for: date)
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: specifiedDate) ?? Date()

        let predicate = NSPredicate(format: "createdAt >= %@ AND createdAt < %@", specifiedDate as NSDate, nextDay as NSDate)
        let list: [Poop] = localRepository.fetch(predicate: predicate)
        return list
    }
    
    public func addPoop(
        color: PoopColor = .undefined,
        shape: PoopShape = .undefined,
        volume: PoopVolume = .undefined,
        memo: String = "",
        createdAt: Date
    ) {
        guard let entity: Poop = localRepository.entity() else { return }
        entity.id = UUID()
        entity.color = color.rawValue
        entity.shape = Int16(shape.rawValue)
        entity.volume = Int16(volume.rawValue)
        entity.memo = memo
        entity.createdAt = createdAt
        localRepository.insert(entity)
        localRepository.save()
    }
    
    public func addPoopSimple(createdAt: Date) {
        addPoop(createdAt: createdAt)
    }
    
    public func updatePoop(
        id : UUID,
        color: PoopColor,
        shape: PoopShape,
        volume: PoopVolume,
        memo: String,
        createdAt: Date
    ) {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let poop: Poop = localRepository.fetchSingle(predicate: predicate) else { return }
        poop.color = color.rawValue
        poop.shape = Int16(shape.rawValue)
        poop.volume = Int16(volume.rawValue)
        poop.memo = memo
        poop.createdAt = createdAt
        localRepository.save()
    }

    public func deletePoop(id : UUID) {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let poop: Poop = localRepository.fetchSingle(predicate: predicate) else { return }
        localRepository.delete(poop)
        localRepository.save()
    }
}
