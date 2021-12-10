//
//  ChatRoomRequestDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 05..
//

import Foundation

struct ChatRoomRequestDTO: Encodable {
    var chatRoomName: String
    var recipientEmail: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(chatRoomName, forKey: .chatRoomName)
        try container.encode(recipientEmail, forKey: .recipientEmail)
    }
    
    enum CodingKeys: String, CodingKey {
        case chatRoomName = "chat_room_name"
        case recipientEmail = "recipient_email"
    }
}
