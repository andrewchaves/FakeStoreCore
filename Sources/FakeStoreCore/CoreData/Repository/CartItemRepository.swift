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
    func fetchCartItems() -> [CartItem]
    func removeProduct(id: Int64)
    func updateQuantity(for id:Int64, isUp: Bool)
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
    
    public func fetchCartItems() -> [CartItem]{
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            //TODO: - Improve error handling
            print(error)
            return []
        }
    }
    
    public func removeProduct(id: Int64) {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id as CVarArg)
        
        do {
            let cartItems = try context.fetch(fetchRequest)
            if let itemToRemove = cartItems.first {
                context.delete(itemToRemove)
                try context.save()
            }
        } catch {
            //TODO: - Improve error handling
            print(error)
        }
    }
    
    public func updateQuantity(for id:Int64, isUp: Bool) {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id as CVarArg)
        
        do {
            let items = try context.fetch(fetchRequest)
            if let itemToBeUpdated = items.first {
                if (isUp){
                    itemToBeUpdated.quantity = itemToBeUpdated.quantity + 1
                } else if (itemToBeUpdated.quantity > 1) {
                    itemToBeUpdated.quantity = itemToBeUpdated.quantity - 1
                }
                try context.save()
            } else {
                print("ID not found!")
            }
        } catch {
            //TODO: - Improve error handling
            print("Error: \(error)")
        }
    }
}
