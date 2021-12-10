//
//  MessageDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 04..
//

import Foundation

class MessageDTO: Decodable {
    var message: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        message = try container.decode(String.self, forKey: .message)
    }
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}
