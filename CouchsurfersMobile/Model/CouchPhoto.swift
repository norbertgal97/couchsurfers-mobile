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
    let fileName = UUID().uuidString
    var uiImage: UIImage
}
