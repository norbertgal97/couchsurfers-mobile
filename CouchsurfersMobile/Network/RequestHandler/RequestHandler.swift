//
//  DefaultRequestHandler.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation

class RequestHandler {
    func makeRequest<T: Encodable>(from data: T, url: URL, method: HTTPMethod) -> URLRequest? {
        guard let encoded = try? JSONEncoder().encode(data) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = encoded
        
        return urlRequest
    }
    
    func makeRequest(url: URL, method: HTTPMethod) -> URLRequest? {
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
