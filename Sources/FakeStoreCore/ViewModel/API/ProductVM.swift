//
//  ProductVM.swift
//  FakeStore
//
//  Created by Andrew Vale on 30/01/25.
//

import Foundation
import Combine

public struct ProductForUI: Identifiable {
    public var id: Int
    public var title: String
    public var price: String
    public var description: String
    public var image: String
    public var category: String
    
    public init(id: Int, title: String, price: String, description: String, image: String, category: String) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.image = image
        self.category = category
    }
    
    public func toProduct() -> Product{
        
        var convertedPrice: Double
        let priceNumberInString = self.price.replacingOccurrences(of: "$", with: "")
        if let priceDouble = Double(priceNumberInString) {
            convertedPrice = priceDouble
        } else {
            convertedPrice = 0.0
        }
        
        return Product(id: self.id,
                       title: self.title,
                       price: convertedPrice,
                       description: self.description,
                       image: self.image,
                       category: self.category)
    }
}

@MainActor
@available(macOS 10.15, *)
public class ProductVM {
    
    @Published public var products: [ProductForUI] = []
    @Published public var filteredProducts: [ProductForUI] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let service = Service()
    
    public init() {}
    
    public func fetchProducts() {
        isLoading = true
                service.makeRequest(endPoint: .products, method: .GET, reponseType: [Product].self)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case let .failure(error) = completion {
                            self?.errorMessage = APIError.networkError(error).localizedDescription
                        }
                    }, receiveValue: { [weak self] products in

                        self?.products = products.map { product in
                            ProductForUI(
                                id: product.id,
                                title: product.title,
                                price: "$\(product.price)",
                                description: product.description,
                                image: product.image,
                                category: product.category
                            )
                        }
                    })
                    .store(in: &cancellables)
                
                DispatchQueue.main.async {
                    self.filteredProducts = self.products
                    self.isLoading = false
                }
    }
    
    public func filterProducts(category: String?) {
        DispatchQueue.main.async {
            if let category = category {
                self.filteredProducts = self.products.filter {$0.category == category}
            } else {
                self.filteredProducts = self.products
            }
        }
    }
}
