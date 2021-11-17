//
//  PersonalInformationDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 25..
//

import Foundation

class PersonalInformationDTO: Codable {
    var id: Int
    var fullName: String
    var phoneNumber: String?
    var email: String
    var userPhoto: UserPhotoDTO?
    
    init(id: Int, fullName: String, phoneNumber: String?, email: String) {
        self.id = id
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.email = email
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        fullName = try container.decode(String.self, forKey: .fullName)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        userPhoto = try container.decodeIfPresent(UserPhotoDTO.self, forKey: .userPhoto)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case email
        case userPhoto = "user_photo"
    }
}
