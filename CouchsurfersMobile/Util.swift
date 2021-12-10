//
//  Util.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 19..
//

import Foundation

extension String {
    func removeSpaces() -> String {
        return components(separatedBy: " ").joined()
    }
}
