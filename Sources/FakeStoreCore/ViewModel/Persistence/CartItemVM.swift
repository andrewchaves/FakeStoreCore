//
//  CartItemVM.swift
//  FakeStore
//
//  Created by Andrew Vale on 20/02/25.
//

import Foundation
import Combine

@available(macOS 10.15, *)
public protocol CartItemViewModelProtocol: ObservableObject {
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
public class CartItemVM: CartItemViewModelProtocol {
    
    @Published public var cartItems: [CartItem] = []
    public var cartItemsPublisher: Published<[CartItem]>.Publisher {
        $cartItems
    }
    
    private let cartItemRepository: any CartItemRepositoryProtocol
    
    public init (cartItemRepository: CartItemRepositoryProtocol) {
        self.cartItemRepository = cartItemRepository
    }
    
    public func fetchCartItems() {
        cartItems = cartItemRepository.fetchCartItems()
    }
    
    public func addProduct(_ product: ProductForUI) {
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
    
    public func removeCartItem(id: Int64) {
        cartItemRepository.removeProduct(id: id)
        fetchCartItems()
    }
    
    public func increaseCartItemQuantity(for id: Int64) {
        cartItemRepository.updateQuantity(for: id, isUp: true)
    }
    
    public func decreaseCartItemQuantity(for id: Int64) {
        cartItemRepository.updateQuantity(for: id, isUp: false)
    }
    
    public func getPriceSum() -> Double {
        return cartItems.reduce(0.0) {$0 + $1.price}
    }
    
    public func getQuantitySum() -> Int16 {
        return cartItems.reduce(0) {$0 + $1.quantity}
    }
}
