//
//  SignUpRequestDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 15..
//

import Foundation

struct SignUpRequestDTO: Codable {
    let email: String
    let password: String
    let fullName: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(fullName, forKey: .fullName)
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case fullName = "full_name"
    }
}
