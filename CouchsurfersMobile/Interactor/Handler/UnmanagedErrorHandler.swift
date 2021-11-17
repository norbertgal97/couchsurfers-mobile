//
//  UnmanagedErrorHandler.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 11. 07..
//

import Foundation
import os

protocol UnmanagedErrorHandler {
    func handleUnmanagedErrors(statusCode: Int?, logger: Logger) -> String
}

extension UnmanagedErrorHandler {
    func handleUnmanagedErrors(statusCode: Int?, logger: Logger) -> String {
        if let unwrappedStatusCode = statusCode {
            logger.debug("Unknown error with status code: \(unwrappedStatusCode)")
            return NSLocalizedString("NetworkError.UnknownError", comment: "Unknown error")
        } else {
            logger.debug("Could not connect to the server!")
            return NSLocalizedString("NetworkError.ConnectionError", comment: "Connection error")
        }
    }
}
