//
//  CouchFilter.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 10..
//

import Foundation

struct CouchFilter {
    var city = ""
    var numberOfGuests = ""
    var toDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    var fromDate = Date()
}
