//
//  UserPhotoDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 25..
//

import Foundation

class UserPhotoDTO: Decodable {
    var id: Int
    let fileName: String
    let url: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        fileName = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
    }
}
