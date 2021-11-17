//
//  MessageRequestDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 04..
//

import Foundation

struct MessageRequestDTO: Encodable {
    var content: String
    var senderId: Int
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(content, forKey: .content)
        try container.encode(senderId, forKey: .senderId)
    }
    
    enum CodingKeys: String, CodingKey {
        case content
        case senderId = "sender_id"
    }
}
