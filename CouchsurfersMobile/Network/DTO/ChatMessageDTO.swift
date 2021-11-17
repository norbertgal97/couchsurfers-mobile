//
//  ChatMessageDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 07..
//

import Foundation

class ChatMessageDTO: Decodable {
    var id: Int
    var senderId: Int
    var senderName: String
    var content: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        senderId = try container.decode(Int.self, forKey: .senderId)
        senderName = try container.decode(String.self, forKey: .senderName)
        content = try container.decode(String.self, forKey: .content)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case senderName = "sender_name"
        case content
    }
}
