//
//  ReviewRequestDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 01..
//

import Foundation

struct ReviewRequestDTO: Encodable {
    var couchId: Int
    var description: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(couchId, forKey: .couchId)
        try container.encode(description, forKey: .description)
    }
    
    enum CodingKeys: String, CodingKey {
        case couchId = "couch_id"
        case description
    }
}
