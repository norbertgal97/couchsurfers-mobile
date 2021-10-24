//
//  ReversePlaceId.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 10..
//

import Foundation

struct ReversePlaceIdDTO: Decodable {
    let result: PlaceIdResultDTO
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case result
        case status
    }
}

struct PlaceIdResultDTO: Decodable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
    }
}
