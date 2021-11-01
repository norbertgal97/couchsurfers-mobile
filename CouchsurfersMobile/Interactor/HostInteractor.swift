//
//  HostInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 02..
//

import Foundation
import os

class HostInteractor {
    private let baseUrl: String
    private let hostsUrl = "/api/v1/hosts"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func getOwnHostedCouch(completionHandler: @escaping (_ couch: HostedCouch?, _ message: String?, _ loggedIn: Bool, _ downloadImage: Bool) -> Void) {
        let networkManager = NetworkManager<OwnHostedCouchDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + hostsUrl + "/own")!, method: .GET)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    if unwrappedStatusCode == 401 {
                        self.logger.debug("Session has expired!")
                        completionHandler(nil, nil, false, false)
                        return
                    }
                }
                
                if let unwrappedError = error {
                    if let unwrappedStatusCode = statusCode {
                        switch unwrappedStatusCode {
                        case 404:
                            message = NSLocalizedString("networkError.couchNotFound", comment: "Couch not found")
                        default:
                            message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(nil, message, true, false)
            case .successful:
                self.logger.debug("Hosted couch loaded with id: \(data!.couchId)")
                completionHandler(self.convertDTOToModel(dto: data!), message, true, true)
            }
            
        }
    }
    
    func hostCouch(couchId: Int, hosted: Bool, completionHandler: @escaping (_ hosted: Bool?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<HostDTO>()
        let hostedDTO = HostDTO(hosted: hosted)
        let urlRequest = networkManager.makeRequest(from: hostedDTO, url: URL(string: baseUrl + hostsUrl + "/\(couchId)")!, method: .PATCH)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    if unwrappedStatusCode == 401 {
                        self.logger.debug("Session has expired!")
                        completionHandler(nil, nil, false)
                        return
                    }
                }
                
                if let unwrappedError = error {
                    if let unwrappedStatusCode = statusCode {
                        switch unwrappedStatusCode {
                        case 404:
                            message = NSLocalizedString("networkError.couchNotFound", comment: "Couch not found")
                        case 403:
                            message = NSLocalizedString("networkError.forbidden", comment: "Forbidden")
                        case 422:
                            message = NSLocalizedString("networkError.emptyFields", comment: "Empty fields")
                        default:
                            message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("Couch hosted with id: \(couchId)")
                completionHandler(data!.hosted, message, true)
            }
            
        }
    }
    
    func filterHostedCouches(couchFilter: CouchFilter, completionHandler: @escaping (_ couchPreviews: [CouchPreview]?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<[CouchPreviewDTO]>()
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let formattedFromDate = dateformat.string(from: couchFilter.fromDate)
        let formattedToDate = dateformat.string(from: couchFilter.toDate)
        
        let url = URL(string: baseUrl +
                            hostsUrl +
                            "/query?city=\(couchFilter.city)&guests=\(couchFilter.numberOfGuests)&checkin=\(formattedFromDate)&checkout=\(formattedToDate)")!
        let urlRequest = networkManager.makeRequest(url: url, method: .GET)
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    if unwrappedStatusCode == 401 {
                        self.logger.debug("Session has expired!")
                        completionHandler(nil, nil, false)
                        return
                    }
                }
                
                if let unwrappedError = error {
                    if let unwrappedStatusCode = statusCode {
                        switch unwrappedStatusCode {
                        case 422:
                            message = NSLocalizedString("networkError.emptyFields", comment: "Empty fields")
                        default:
                            message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("Couch previews loaded. Count: \(data!.count)")
                completionHandler(self.convertPreviewDTOToPreviewModel(dto: data!), message, true)
            }
            
        }
    }
    
    private func convertPreviewDTOToPreviewModel(dto: [CouchPreviewDTO]) -> [CouchPreview] {
        var previews = [CouchPreview]()
        
        for preview in dto {
            previews.append(CouchPreview(id: preview.id, name: preview.name, city: preview.city, price: String(preview.price), couchPhotoId: preview.couchPhotoId))
        }
        
        return previews
    }
    
    private func convertDTOToModel(dto: OwnHostedCouchDTO) -> HostedCouch {
        var hostedCouch = HostedCouch()
        
        hostedCouch.id = dto.couchId
        hostedCouch.couchPhotoId = dto.couchPhotoId
        hostedCouch.name = dto.name
        hostedCouch.about = dto.about ?? ""
        hostedCouch.hosted = dto.hosted
        
        var reservations = [UserReservation]()
        if let unwrappedReservations = dto.reservations {
            for reservation in unwrappedReservations {
                var newReservation = UserReservation(id: reservation.id)
                newReservation.name = reservation.name
                newReservation.email = reservation.email
                newReservation.startDate = reservation.startDate
                newReservation.endDate = reservation.endDate
                newReservation.numberOfGuests = String(reservation.numberOfGuests)
                newReservation.userPhotoUrl = reservation.userPhoto?.url
                
                reservations.append(newReservation)
            }
        }
        
        hostedCouch.reservations.append(contentsOf: reservations)
        
        return hostedCouch
    }
    
    private func handleUnmanagedErrors(statusCode: Int?) -> String {
        if let unwrappedStatusCode = statusCode {
            self.logger.debug("Unknown error with status code: \(unwrappedStatusCode)")
            return NSLocalizedString("networkError.unknownError", comment: "Unknown error")
        } else {
            self.logger.debug("Could not connect to the server!")
            return NSLocalizedString("networkError.connectionError", comment: "Connection error")
        }
    }
}
