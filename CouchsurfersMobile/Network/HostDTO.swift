//
//  HostDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 05..
//

import Foundation

class HostDTO: Codable {
    var hosted: Bool
    
    init(hosted: Bool) {
        self.hosted = hosted
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        hosted = try container.decode(Bool.self, forKey: .hosted)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hosted, forKey: .hosted)
    }
    
    enum CodingKeys: String, CodingKey {
        case hosted
    }
}
