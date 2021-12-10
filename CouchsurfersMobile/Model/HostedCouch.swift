//
//  HostedCouch.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 02..
//

import Foundation

struct HostedCouch {
    var id: Int?
    var name = ""
    var about = ""
    var couchPhotoId: String?
    var hosted: Bool = false
    var reservations = [UserReservation]()
}
