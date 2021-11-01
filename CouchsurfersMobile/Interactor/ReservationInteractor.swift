//
//  ReservationInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 20..
//

import Foundation
import os

class ReservationInteractor {
    
    private let baseUrl: String
    private let reservationsUrl = "/api/v1/reservations"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func reserveCouch(_ filter: CouchFilter, couchId: Int, completionHandler: @escaping (_ reserved: Bool?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<ReserveDTO>()
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let formattedFromDate = dateformat.string(from: filter.fromDate)
        let formattedToDate = dateformat.string(from: filter.toDate)
        
        let reserveCouchDTO = ReserveCouchDTO(couchId: couchId, startDate: formattedFromDate, endDate: formattedToDate, numberOfGuests: Int(filter.numberOfGuests)!)
        let urlRequest = networkManager.makeRequest(from: reserveCouchDTO, url: URL(string: baseUrl + reservationsUrl + "/")!, method: .POST)
        
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
                        case 422:
                            message = "Could not reserve this couch"
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
                self.logger.debug("Couch reserved with id: \(couchId)")
                completionHandler(data!.reserved, message, true)
            }
            
        }
        
    }
    
    func loadReservations(completionHandler: @escaping (_ reservationPreviews: [ReservationPreview]?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<[ReservationPreviewDTO]>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + reservationsUrl + "/")!, method: .GET)
        
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
                    if statusCode != nil {
                        message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("Reservations are loaded. Count: \(data!.count)")
                completionHandler(self.convertPreviewDTOToPreviewModel(dto: data!), message, true)
            }
            
        }
    }
    
    func loadReservationDetails(with id: Int, completionHandler: @escaping (_ reservation: Reservation?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<ReservationDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + reservationsUrl + "/\(id)")!, method: .GET)
        
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
                            message = NSLocalizedString("networkError.couchNotFound", comment: "Reservation not found")
                        case 403:
                            message = "You can't access this resource!"
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
                self.logger.debug("Reservation loaded with id: \(id)")
                completionHandler(self.convertReservationDTOToReservatioModel(dto: data!), message, true)
            }
            
        }
    }
    
    func cancelReservation(with id: Int, completionHandler: @escaping (_ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<MessageDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + reservationsUrl + "/\(id)")!, method: .DELETE)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    if unwrappedStatusCode == 401 {
                        self.logger.debug("Session has expired!")
                        completionHandler(nil, false)
                        return
                    }
                }
                
                if let unwrappedError = error {
                    if let unwrappedStatusCode = statusCode {
                        switch unwrappedStatusCode {
                        case 404:
                            message = "Reservation not found"
                        case 403:
                            message = NSLocalizedString("networkError.forbidden", comment: "Forbidden")
                        case 409:
                            message = "Too late to cancel."
                        default:
                            message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(message, true)
            case .successful:
                self.logger.debug("Reservation is cancelled with id: \(id)")
                completionHandler(message, true)
            }
            
        }
    }
    
    private func convertReservationDTOToReservatioModel(dto: ReservationDTO) -> Reservation {
        var reservation = Reservation(id: dto.id)
        
        reservation.startDate = dto.startDate
        reservation.endDate = dto.endDate
        reservation.reservationNumberOfGuests = String(dto.numberOfGuests)
        reservation.zipCode = dto.couch.location.zipCode ?? ""
        reservation.city = dto.couch.location.city
        reservation.street = dto.couch.location.street ?? ""
        reservation.buildingNumber = dto.couch.location.buildingNumber ?? ""
        reservation.name = dto.couch.name
        reservation.numberOfRooms = String(dto.couch.numberOfRooms)
        reservation.couchNumberOfGuests = String(dto.couch.numberOfGuests)
        reservation.amenities = dto.couch.amenities ?? ""
        reservation.price = String(dto.couch.price)
        reservation.about = dto.couch.about ?? ""
        
        if let unwrappedPhotos = dto.couch.couchPhotos {
            for couchPhoto in unwrappedPhotos  {
                let newElement = convertCouchPhotoDTOToModel(dto: couchPhoto)
                reservation.couchPhotos.append(newElement)
            }
        }
        
        return reservation
    }
    
    private func convertCouchPhotoDTOToModel(dto: CouchPhotoDTO) -> CouchPhoto {
        var couchPhoto = CouchPhoto()
        
        couchPhoto.id = dto.id
        couchPhoto.fileName = dto.fileName
        couchPhoto.url = dto.url
        
        return couchPhoto
    }
    
    private func convertPreviewDTOToPreviewModel(dto: [ReservationPreviewDTO]) -> [ReservationPreview] {
        var previews = [ReservationPreview]()
        
        for preview in dto {
            previews.append(ReservationPreview(id: preview.id,
                                               couchId: preview.couchId,
                                               couchPhotoId: preview.couchPhotoId,
                                               name: preview.name,
                                               city: preview.city,
                                               price: String(preview.price),
                                               startDate: preview.startDate,
                                               endDate: preview.endDate,
                                               active: preview.active,
                                               numberOfGuests: String(preview.numberOfGuests)))
        }
        
        return previews
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
