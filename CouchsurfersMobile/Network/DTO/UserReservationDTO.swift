//
//  UserReservationDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 29..
//

import Foundation

class UserReservationDTO: Decodable {
    var id: Int
    var name: String
    var email: String
    var startDate: String
    var endDate: String
    var numberOfGuests: Int
    var userPhoto: UserPhotoDTO?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        startDate = try container.decode(String.self, forKey: .startDate)
        endDate = try container.decode(String.self, forKey: .endDate)
        numberOfGuests = try container.decode(Int.self, forKey: .numberOfGuests)
        userPhoto = try container.decodeIfPresent(UserPhotoDTO.self, forKey: .userPhoto)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case startDate = "start_date"
        case endDate = "end_date"
        case numberOfGuests = "number_of_guests"
        case userPhoto = "user_photo"
    }
}
