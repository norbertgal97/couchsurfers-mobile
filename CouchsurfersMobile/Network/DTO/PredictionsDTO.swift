//
//  PredictionsDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation

class PredictionsDTO: Decodable {
    var all: [PlaceDTO]
    var status: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try container.decode(String.self, forKey: .status)
        all = try container.decode([PlaceDTO].self, forKey: .all)
    }
    
    enum CodingKeys: String, CodingKey {
        case all = "predictions"
        case status
    }
}

class PlaceDTO: Decodable {
    var id: String
    var description: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case description
    }
}
