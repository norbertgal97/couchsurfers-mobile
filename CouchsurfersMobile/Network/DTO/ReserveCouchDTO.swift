//
//  ReserveCouchDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 20..
//

import Foundation

struct ReserveCouchDTO: Codable {
    let couchId: Int
    let startDate: String
    let endDate: String
    let numberOfGuests: Int
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(couchId, forKey: .couchId)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(numberOfGuests, forKey: .numberOfGuests)
    }
    
    enum CodingKeys: String, CodingKey {
        case couchId = "couch_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case numberOfGuests = "number_of_guests"
    }
}
