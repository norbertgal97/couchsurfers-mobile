//
//  ErrorDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import Foundation

class ErrorDTO: Decodable {
    var errorCode: Int
    var errorMessage: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        errorCode = try container.decode(Int.self, forKey: .errorCode)
        errorMessage = try container.decode(String.self, forKey: .errorMessage)
    }
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
