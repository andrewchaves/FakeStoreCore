//
//  AppContainer.swift
//  FakeStore
//
//  Created by Andrew Vale on 24/04/25.
//

import Foundation

@MainActor
public final class AppContainer {
    public static let shared = AppContainer()
    
    public let coreDataManager: CoreDataManager
    public let cartItemRepository: CartItemRepository
    
    private init() {
        self.coreDataManager = CoreDataManager(modelName: "FakeStore")
        self.cartItemRepository = CartItemRepository(coreDataManager: coreDataManager)
    }
}
