//
//  CartItemRepository.swift
//  FakeStore
//
//  Created by Andrew Vale on 17/02/25.
//

import CoreData

@MainActor
public protocol CartItemRepositoryProtocol {
    func addProduct(id: Int64, name: String, quantity: Int16, price: Double, image: String) async throws
    func fetchCartItems() throws -> [CartItem]
    func removeProduct(id: Int64) throws
    func updateQuantity(for id:Int64, isUp: Bool) throws
}

@MainActor
public class CartItemRepository: CartItemRepositoryProtocol {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    public func addProduct(id: Int64, name: String, quantity: Int16, price: Double, image: String) async throws {
        
        let backgroundContext = coreDataManager.backgroundContext
        
        try await backgroundContext.perform {
            let newCartItem = CartItem(context: backgroundContext)
            newCartItem.id = id
            newCartItem.name = name
            newCartItem.quantity = quantity
            newCartItem.price = price
            newCartItem.image = image
            
            try backgroundContext.save()
        }
    }
    
    public func fetchCartItems() throws -> [CartItem]{
        
        let context = coreDataManager.viewContext
        
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        
        return try context.fetch(fetchRequest)
        
    }
    
    public func removeProduct(id: Int64) throws {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id as CVarArg)
        
        let cartItems = try context.fetch(fetchRequest)
        
        if let itemToRemove = cartItems.first {
            context.delete(itemToRemove)
            try context.save()
        }
    }
    
    public func updateQuantity(for id:Int64, isUp: Bool) throws {
        
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id as CVarArg)
        
        let items = try context.fetch(fetchRequest)
        
        guard let itemToBeUpdated = items.first  else {
            return
        }
        
        if (isUp){
            itemToBeUpdated.quantity = itemToBeUpdated.quantity + 1
        } else if (itemToBeUpdated.quantity > 1) {
            itemToBeUpdated.quantity = itemToBeUpdated.quantity - 1
        }
        
        try context.save()
    }
}
