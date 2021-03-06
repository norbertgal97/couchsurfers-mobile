//
//  OwnHostedCouchDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 02..
//

import Foundation

class OwnHostedCouchDTO: Decodable {
    var couchId: Int
    var couchPhotoId: String?
    var name: String
    var about: String?
    var hosted: Bool
    var reservations: [UserReservationDTO]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        couchId = try container.decode(Int.self, forKey: .couchId)
        couchPhotoId = try container.decodeIfPresent(String.self, forKey: .couchPhotoId)
        name = try container.decode(String.self, forKey: .name)
        about = try container.decodeIfPresent(String.self, forKey: .about)
        hosted = try container.decode(Bool.self, forKey: .hosted)
        reservations = try container.decodeIfPresent([UserReservationDTO].self, forKey: .reservations)
    }
    
    enum CodingKeys: String, CodingKey {
        case couchId = "couch_id"
        case couchPhotoId = "couch_photo_id"
        case name
        case about
        case hosted
        case reservations
    }
}
