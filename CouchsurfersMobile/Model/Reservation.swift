//
//  Reservation.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 24..
//

import Foundation

struct Reservation {
    var id: Int
    var name = ""
    var city = ""
    var zipCode = ""
    var street = ""
    var buildingNumber = ""
    var couchNumberOfGuests = ""
    var reservationNumberOfGuests = ""
    var numberOfRooms = ""
    var amenities = ""
    var about = ""
    var price = ""
    var startDate = ""
    var endDate = ""
    var ownerName = ""
    var ownerEmail = ""
    var couchPhotos = [CouchPhoto]()
}
