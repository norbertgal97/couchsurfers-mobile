//
//  ReviewDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 31..
//

import Foundation

class ReviewDTO: Decodable {
    var id: Int
    var name: String
    var description: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
}
