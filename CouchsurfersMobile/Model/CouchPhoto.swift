//
//  CouchPhoto.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 03..
//

import Foundation
import UIKit

struct CouchPhoto {
    var id: Int?
    var fileName = UUID().uuidString
    var url: String?
    var uiImage: UIImage?
}
