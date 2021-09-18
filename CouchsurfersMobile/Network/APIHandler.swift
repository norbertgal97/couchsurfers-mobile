//
//  APIHandler.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 17..
//

import Foundation

struct APIHandler<T: Encodable, U: Decodable> {
    private let endpoint: Endpoint<T, U>
    
    init(endpoint: Endpoint<T, U>) {
        self.endpoint = endpoint
    }
    
    func loadData(with request: T, completionHandler: @escaping (NetworkStatus, U?, ErrorDTO?) -> Void) {
        
        guard let urlRequest = endpoint.makeRequest(from: request) else {
            completionHandler(.failure(statusCode: nil), nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
                //let outputStr  = String(data: data, encoding: String.Encoding.utf8) as String?
                //print(outputStr)
                
                let decodedData = try endpoint.decodeResponse(from: data, httpResponse: httpResponse)
                
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
