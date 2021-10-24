//
//  CouchDTO.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 24..
//

import Foundation

class CouchDTO: Codable {
    var id: Int?
    var name: String
    var numberOfGuests: Int
    var numberOfRooms: Int
    var about: String?
    var amenities: String?
    var price: Double
    var couchPhotos: [CouchPhotoDTO]?
    var location: LocationDTO
    
    init(name: String, numberOfRooms: Int, numberOfGuests: Int, price: Double, location: LocationDTO) {
        self.name = name
        self.numberOfRooms = numberOfRooms
        self.numberOfGuests = numberOfGuests
        self.price = price
        self.location = location
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        numberOfGuests = try container.decode(Int.self, forKey: .numberOfGuests)
        numberOfRooms = try container.decode(Int.self, forKey: .numberOfRooms)
        about = try container.decodeIfPresent(String.self, forKey: .about)
        amenities = try container.decodeIfPresent(String.self, forKey: .amenities)
        price = try container.decode(Double.self, forKey: .price)
        location = try container.decode(LocationDTO.self, forKey: .location)
        couchPhotos = try container.decodeIfPresent([CouchPhotoDTO].self, forKey: .couchPhotos)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(numberOfGuests, forKey: .numberOfGuests)
        try container.encode(numberOfRooms, forKey: .numberOfRooms)
        try container.encodeIfPresent(about, forKey: .about)
        try container.encodeIfPresent(amenities, forKey: .amenities)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encode(location, forKey: .location)
        //try container.encodeIfPresent(couchPhotos, forKey: .couchPhotos)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case numberOfGuests = "number_of_guests"
        case numberOfRooms = "number_of_rooms"
        case about
        case amenities
        case price
        case location
        case couchPhotos = "couch_photos"
    }
}
