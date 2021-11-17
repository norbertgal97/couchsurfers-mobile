//
//  ChatRoomDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 05..
//

import Foundation

class ChatRoomDTO: Codable {
    var id: Int
    var myId: Int
    var chatRoomName: String
    var recipientEmail: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        myId = try container.decode(Int.self, forKey: .myId)
        chatRoomName = try container.decode(String.self, forKey: .chatRoomName)
        recipientEmail = try container.decode(String.self, forKey: .recipientEmail)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case myId = "my_id"
        case chatRoomName = "chat_room_name"
        case recipientEmail = "recipient_email"
    }
}
