//
//  SignUpResponseDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 18..
//

import Foundation

class SignUpResponseDTO: Decodable {
    var userId: Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userId = try container.decode(Int.self, forKey: .userId)
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
    }
}
