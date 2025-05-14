//
//  Product.swift
//  FakeStore
//
//  Created by Andrew Vale on 29/01/25.
//

import Foundation

public struct Product: Codable {
    public var id: Int
    public var title: String
    public var price: Double
    public var description: String
    public var image: String
    public var category: String
}
