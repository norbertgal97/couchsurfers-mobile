//
//  LocationDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 24..
//

import Foundation

class LocationDTO: Codable {
    var zipCode: String?
    var city: String
    var street: String?
    var buildingNumber: String?
    
    // photos
    
    init(city: String) {
        self.city = city
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        zipCode = try container.decodeIfPresent(String.self, forKey: .zipCode)
        city = try container.decode(String.self, forKey: .city)
        street = try container.decodeIfPresent(String.self, forKey: .street)
        buildingNumber = try container.decodeIfPresent(String.self, forKey: .buildingNumber)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(zipCode, forKey: .zipCode)
        try container.encode(city, forKey: .city)
        try container.encodeIfPresent(street, forKey: .street)
        try container.encodeIfPresent(buildingNumber, forKey: .buildingNumber)
    }
    
    enum CodingKeys: String, CodingKey {
        case zipCode = "zip_code"
        case city
        case street
        case buildingNumber = "building_number"
    }
}
