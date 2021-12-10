//
//  CouchPreviewDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 06..
//

import Foundation

class CouchPreviewDTO: Codable {
    var id: Int
    var name: String
    var price: Double
    var city: String
    var couchPhotoId: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        city = try container.decode(String.self, forKey: .city)
        couchPhotoId = try container.decodeIfPresent(String.self, forKey: .couchPhotoId)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "couch_id"
        case name
        case price
        case city
        case couchPhotoId = "couch_photo_id"
    }
}
