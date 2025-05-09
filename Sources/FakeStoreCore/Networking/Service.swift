//
//  Service.swift
//  FakeStore
//
//  Created by Andrew Vale on 29/01/25.
//

import Foundation
import Combine

enum APIEndpoint {
    case products
    case categories
    
    var path: String {
        switch self {
        case .products:
            return "/products"
        case .categories:
            return "/products/categories"
        }
    }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError
    case unknownError
}

@available(macOS 10.15, *)
class Service {
    
    private let baseURL: String = "https://fakestoreapi.com"
    
    func makeRequest<T: Decodable> (endPoint: APIEndpoint,
                                    method: HTTPMethod,
                                    body: Data? = nil,
                                    headers: [String: String] = [:],
                                    reponseType: T.Type) -> AnyPublisher<T, APIError> {
        //Check if url is ok
        guard let url = URL(string: "\(baseURL)\(endPoint.path)") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        //Config request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
               .tryMap { data, response in
                   guard let httpResponse = response as? HTTPURLResponse,
                         (200...299).contains(httpResponse.statusCode) else {
                       throw APIError.invalidResponse
                   }
                   return data
               }
               .decode(type: T.self, decoder: JSONDecoder())
               .mapError { error in
                   if let apiError = error as? APIError {
                       return apiError
                   } else if error is DecodingError {
                       return APIError.decodingError
                   } else {
                       return APIError.networkError(error)
                   }
               }
               .eraseToAnyPublisher()
    }
}
