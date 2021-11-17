//
//  LoginRequestDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import Foundation

struct LoginRequestDTO: Codable {
    let email: String
    let password: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
    
    enum CodingKeys: CodingKey {
        case email, password
    }
}

