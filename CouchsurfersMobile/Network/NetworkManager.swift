//
//  APIHandler.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 17..
//

import SwiftUI

class NetworkManager<Res: Decodable> {
    
    private let responseHandler: ResponseHandler<Res>
    private let requestHandler: RequestHandler
    
    init(requestHandler: RequestHandler = RequestHandler(), responseHandler: ResponseHandler<Res> = ResponseHandler()) {
        self.responseHandler = responseHandler
        self.requestHandler = requestHandler
    }
    
    func makeRequest<T: Encodable>(from data: T, url: URL, method: HTTPMethod) -> URLRequest? {
        requestHandler.makeRequest(from: data, url: url, method: method)
    }
    
    func makeRequest(url: URL, method: HTTPMethod) -> URLRequest? {
        requestHandler.makeRequest(url: url, method: method)
    }
    
    func makeRequest(from dictionary: [String: Any?], url: URL, method: HTTPMethod) -> URLRequest? {
        requestHandler.makeRequest(from: dictionary, url: url, method: method)
    }
    
    private func decodeResponse(from data: Data, httpResponse: HTTPURLResponse) throws -> Res {
        try responseHandler.decodeResponse(from: data, httpResponse: httpResponse)
    }
    
    func dataTask(with URLRequest: URLRequest?, completionHandler: @escaping (NetworkStatus, Res?, ErrorDTO?) -> Void) {
        
        guard let unwrappedURLRequest = URLRequest else {
            completionHandler(.failure(statusCode: nil), nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: unwrappedURLRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(statusCode: nil), nil, nil)
                return
            }
            
            guard error == nil else {
                completionHandler(.failure(statusCode: httpResponse.statusCode), nil, nil)
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(statusCode: httpResponse.statusCode), nil, nil)
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            do {
                let decodedData: Res = try self.decodeResponse(from: data, httpResponse: httpResponse)
                
                completionHandler(.successful, decodedData, nil)
            } catch {
                do {
                    let decodedError = try JSONDecoder().decode(ErrorDTO.self, from: data)
                    completionHandler(.failure(statusCode: httpResponse.statusCode), nil, decodedError)
                } catch {
                    completionHandler(.failure(statusCode: httpResponse.statusCode), nil, nil)
                }
            }
            
        }.resume()
        
    }
    
    func uploadTask(data: Data, boundary: String, with URLRequest: URLRequest?, completionHandler: @escaping (NetworkStatus, Res?, ErrorDTO?) -> Void) {
        guard let unwrappedURLRequest = URLRequest else {
            completionHandler(.failure(statusCode: nil), nil, nil)
            return
        }
        
        URLSession.shared.uploadTask(with: unwrappedURLRequest, from: data) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(statusCode: nil), nil, nil)
                return
            }
            
            guard error == nil else {
                completionHandler(.failure(statusCode: httpResponse.statusCode), nil, nil)
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(statusCode: httpResponse.statusCode), nil, nil)
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            do {
                let decodedData: Res = try self.decodeResponse(from: data, httpResponse: httpResponse)
                
                completionHandler(.successful, decodedData, nil)
            } catch {
                do {
                    let decodedError = try JSONDecoder().decode(ErrorDTO.self, from: data)
                    completionHandler(.failure(statusCode: httpResponse.statusCode), nil, decodedError)
                } catch {
                    completionHandler(.failure(statusCode: httpResponse.statusCode), nil, nil)
                }
            }
            
        }.resume()
    }
}
