//
//  DefaultResponseHandler.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation

class ResponseHandler<Res :Decodable> {

    func decodeResponse(from data: Data, httpResponse: HTTPURLResponse) throws -> Res {
        let decodedData = try JSONDecoder().decode(Res.self, from: data)
        
        return decodedData
    }
}
