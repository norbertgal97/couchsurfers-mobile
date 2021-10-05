//
//  UploadRequestHandler.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 03..
//

import Foundation

class UploadRequestHandler: RequestHandler {
    let boundary: String
    
    init(boundary: String) {
        self.boundary = boundary
    }
    
    override func makeRequest(url: URL, method: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}
