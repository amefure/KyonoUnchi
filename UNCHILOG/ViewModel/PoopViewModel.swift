//
//  PoopViewModel.swift
//  UNCHILOG
//
//  Created by t&a on 2024/03/26.
//

import UIKit

class PoopViewModel: ObservableObject {
    
    static let shared = PoopViewModel()
    
    @Published private(set) var poops: [Poop] = []

    private var repository: PoopRepository
    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.poopRepository
    }
}

extension PoopViewModel {
    
    public func fetchAllPoops() {
        poops = repository.fetchAllPoops()
    
    }
    
    public func addPoop(color: PoopColor, shape: PoopShape, volume: PoopVolume, hardness: PoopHardness, memo: String, createdAt: Date) {
        repository.addPoop(color: color, shape: shape, volume: volume, hardness: hardness, memo: memo, createdAt: createdAt)
        fetchAllPoops()
    }

    public func updatePoop(id : UUID, color: PoopColor, shape: PoopShape, volume: PoopVolume, hardness: PoopHardness, memo: String) {
        repository.updatePoop(id: id, color: color, shape: shape, volume: volume, hardness: hardness, memo: memo)
        fetchAllPoops()
    }
    
    
    public func onAppear(){
        fetchAllPoops()
    }
    
    
    public func deletePoop(poop: Poop) {
        repository.deletePoop(id: poop.wrappedId)
        fetchAllPoops()
    }
}
