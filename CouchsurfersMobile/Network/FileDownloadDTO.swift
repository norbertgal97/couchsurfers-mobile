//
//  FileDownloadDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 02..
//

import Foundation

class FileDownloadDTO: Decodable {
    var imageId: Int
    var name: String
    var content: Data
    var type: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        imageId = try container.decode(Int.self, forKey: .imageId)
        name = try container.decode(String.self, forKey: .name)
        content = try container.decode(Data.self, forKey: .content)
        type = try container.decode(String.self, forKey: .type)
    }
    
    enum CodingKeys: String, CodingKey {
        case imageId = "id"
        case name
        case content
        case type
    }
}
