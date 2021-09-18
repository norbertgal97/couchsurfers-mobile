//
//  NetworkStatus.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 17..
//

import Foundation

enum NetworkStatus {
    case successful
    case failure(statusCode: Int?)
}
