//
//  Endpoint.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 18..
//

import Foundation

class Endpoint<T: Encodable, U: Decodable> {
    let url: URL
    let method: HTTPMethod
    
    init(url: URL, method: HTTPMethod) {
        self.url = url
        self.method = method
    }
    
    
    func makeRequest(from data: T) -> URLRequest? {
        guard let encoded = try? JSONEncoder().encode(data) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = encoded
        
        return urlRequest
    }
    
    func decodeResponse(from data: Data, httpResponse: HTTPURLResponse) throws -> U {
        let decodedData = try JSONDecoder().decode(U.self, from: data)
        
        return decodedData
    }
}

