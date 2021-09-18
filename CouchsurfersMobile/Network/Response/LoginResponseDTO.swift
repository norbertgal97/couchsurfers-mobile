//
//  ResponseDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 18..
//

import Foundation

class LoginResponseDTO: Decodable {
    var userId: Int
    var sessionId: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userId = try container.decode(Int.self, forKey: .userId)
        
        sessionId = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
    }
}
