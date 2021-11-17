//
//  ProfileDataDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 27..
//

import Foundation

class ProfileDataDTO: Decodable {
    var fullName: String
    var userPhoto: UserPhotoDTO?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fullName = try container.decode(String.self, forKey: .fullName)
        userPhoto = try container.decodeIfPresent(UserPhotoDTO.self, forKey: .userPhoto)
    }
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case userPhoto = "user_photo"
    }
}
