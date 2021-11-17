//
//  ReservationDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 21..
//

import Foundation

class ReservationPreviewDTO: Codable {
    var id: Int
    var couchId: Int
    var couchPhotoId: String?
    var name: String
    var city: String
    var price: Double
    var startDate: String
    var endDate: String
    var active: Bool
    var numberOfGuests: Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        couchId = try container.decode(Int.self, forKey: .couchId)
        couchPhotoId = try container.decodeIfPresent(String.self, forKey: .couchPhotoId)
        name = try container.decode(String.self, forKey: .name)
        city = try container.decode(String.self, forKey: .city)
        price = try container.decode(Double.self, forKey: .price)
        startDate = try container.decode(String.self, forKey: .startDate)
        endDate = try container.decode(String.self, forKey: .endDate)
        active = try container.decode(Bool.self, forKey: .active)
        numberOfGuests = try container.decode(Int.self, forKey: .numberOfGuests)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case couchId = "couch_id"
        case couchPhotoId = "couch_photo_id"
        case name
        case city
        case price
        case startDate = "start_date"
        case endDate = "end_date"
        case active
        case numberOfGuests = "number_of_guests"
    }
}
