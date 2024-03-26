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
    
    public func fetchAllCategorys() {
        poops = repository.fetchAllPoops()
    
    }
    
    public func addCategory(name: String, color: String) {
        repository.addPoop(color: <#T##PoopColor#>, shape: <#T##PoopShape#>, volume: <#T##PoopVolume#>, hardness: <#T##PoopHardness#>, memo: <#T##String#>)
    }
    
    public func updateCategory(id: UUID, name: String, color: String) {
        repository.updateCategory(categoryId: id, name: name, color: color)
    }
    
    private func updateOrder(id: UUID, order: Int) {
        repository.updateOrder(categoryId: id, order: order)
    }
    
    public func onAppear(){
        fetchAllCategorys()
    }
    
    
   
    public func deleteCategory(poop: Poop) {
        repository.deleteCategory(categoryId: poop.)
    }
}
