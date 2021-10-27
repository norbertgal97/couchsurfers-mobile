//
//  UserPhoto.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 25..
//

import UIKit

struct UserPhoto {
    var id: Int?
    var fileName = UUID().uuidString
    var url: String?
    var uiImage: UIImage?
}
