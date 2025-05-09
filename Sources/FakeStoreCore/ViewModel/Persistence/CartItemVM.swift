//
//  CartItemVM.swift
//  FakeStore
//
//  Created by Andrew Vale on 20/02/25.
//

import Foundation
import Combine

@available(macOS 10.15, *)
protocol CartItemViewModelProtocol: ObservableObject {
    var cartItems: [CartItem] { get }
    var cartItemsPublisher: Published<[CartItem]>.Publisher { get }
    func fetchCartItems()
    func addProduct(_ product: ProductForUI)
    func removeCartItem(id: Int64)
    func increaseCartItemQuantity(for id: Int64)
    func decreaseCartItemQuantity(for id: Int64)
    func getPriceSum() -> Double
    func getQuantitySum() -> Int16
}

@available(macOS 10.15, *)
class CartItemVM: CartItemViewModelProtocol {
    
    @Published var cartItems: [CartItem] = []
    var cartItemsPublisher: Published<[CartItem]>.Publisher {
        $cartItems
    }
    
    private let cartItemRepository: any CartItemRepositoryProtocol
    
    init (cartItemRepository: CartItemRepositoryProtocol) {
        self.cartItemRepository = cartItemRepository
        fetchCartItems()
    }
    
    func fetchCartItems() {
        cartItems = cartItemRepository.fetchCartItems()
    }
    
    func addProduct(_ product: ProductForUI) {
        let product = product.toProduct()
        if !cartItems.contains(where: { $0.id == product.id}) {
            cartItemRepository.addProduct(id: Int64(product.id),
                                          name: product.title,
                                          quantity:  1,
                                          price: product.price,
                                          image: product.image)
        }
        fetchCartItems()
    }
    
    func removeCartItem(id: Int64) {
        cartItemRepository.removeProduct(id: id)
        fetchCartItems()
    }
    
    func increaseCartItemQuantity(for id: Int64) {
        cartItemRepository.updateQuantity(for: id, isUp: true)
        fetchCartItems()
    }
    
    func decreaseCartItemQuantity(for id: Int64) {
        cartItemRepository.updateQuantity(for: id, isUp: false)
        fetchCartItems()
    }
    
    func getPriceSum() -> Double {
        return cartItems.reduce(0.0) {$0 + $1.price}
    }
    
    func getQuantitySum() -> Int16 {
        return cartItems.reduce(0) {$0 + $1.quantity}
    }
}
