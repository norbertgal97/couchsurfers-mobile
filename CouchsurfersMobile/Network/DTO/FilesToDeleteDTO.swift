//
//  FilesToDeleteDTo.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 04..
//

import Foundation

struct FilesToDeleteDTO: Codable {
    let ids: [Int]
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(ids, forKey: .ids)
    }
    
    enum CodingKeys: CodingKey {
        case ids
    }
}
