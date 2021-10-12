//
//  Couch.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 20..
//

import Foundation

struct Couch {
    var id: Int?
    var name = ""
    var city = ""
    var zipCode = ""
    var street = ""
    var buildingNumber = ""
    var numberOfGuests = ""
    var numberOfRooms = ""
    var amenities = ""
    var about = ""
    var price = ""
    var couchPhotos = [CouchPhoto]()
}
