//
//  PlaceIdResultDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 11..
//

import Foundation

struct PlaceIdResultDTO: Decodable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
    }
}
