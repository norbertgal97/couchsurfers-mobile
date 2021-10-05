//
//  FileUploadDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 03..
//

import Foundation

class FileUploadDTO: Decodable {
    var id: Int
    var size: Int
    var name: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        size = try container.decode(Int.self, forKey: .size)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case size
    }
}
