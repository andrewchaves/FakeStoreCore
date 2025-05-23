//
//  CategoryVM.swift
//  FakeStore
//
//  Created by Andrew Vale on 12/02/25.
//

import Foundation
import Combine

@MainActor
@available(macOS 10.15, *)
public class CategorytVM: ObservableObject {
    
    @Published public var categories: [Category] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let service = Service()
    
    public init() {}
    
    public func fetchCategories() {
        isLoading = true
                service.makeRequest(endPoint: .categories, method: .GET, reponseType: [String].self)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        if case let .failure(error) = completion {
                            self?.errorMessage = APIError.networkError(error).localizedDescription
                        }
                    }, receiveValue: { [weak self] categories in
                        self?.categories = categories.map {
                            Category(
                                name: $0
                            )
                        }
                    })
                    .store(in: &cancellables)
    }
}
