//
//  ReservationDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 24..
//

import Foundation

class ReservationDTO: Codable {
    var id: Int
    var startDate: String
    var endDate: String
    var numberOfGuests: Int
    var couch: CouchDTO
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        startDate = try container.decode(String.self, forKey: .startDate)
        endDate = try container.decode(String.self, forKey: .endDate)
        numberOfGuests = try container.decode(Int.self, forKey: .numberOfGuests)
        couch = try container.decode(CouchDTO.self, forKey: .couch)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case startDate = "start_date"
        case endDate = "end_date"
        case numberOfGuests = "number_of_guests"
        case couch
    }
}
