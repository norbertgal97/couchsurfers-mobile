//
//  ReserveDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 20..
//

import Foundation

class ReserveDTO: Codable {
    var reserved: Bool
    
    init(reserved: Bool) {
        self.reserved = reserved
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        reserved = try container.decode(Bool.self, forKey: .reserved)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(reserved, forKey: .reserved)
    }
    
    enum CodingKeys: String, CodingKey {
        case reserved
    }
}
