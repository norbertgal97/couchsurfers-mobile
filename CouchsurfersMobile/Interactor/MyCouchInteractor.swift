//
//  MyCouchInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 27..
//

import os
import UIKit

class MyCouchInteractor {
    
    private let baseUrl: String
    private let couchesUrl = "couches"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func loadCouch(with id: Int, completionHandler: @escaping (_ couch: Couch?, _ message: String?, _ loggedIn: Bool, _ downloadImage: Bool) -> Void) {
        let networkManager = NetworkManager<CouchDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + couchesUrl + "/\(id)")!, method: .GET)
        
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
                        case 403:
                            message = NSLocalizedString("networkError.forbidden", comment: "Forbidden")
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
                self.logger.debug("Couch loaded with id: \(id)")
                completionHandler(self.convertDTOToModel(dto: data!), message, true, true)
            }
            
        }
    }
    
    func updateCouch(with id: Int, myCouch: Couch, savedCouch: Couch?, completionHandler: @escaping (_ couch: Couch?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let dictionary = convertModelToDictionary(model: myCouch, savedModel: savedCouch)
        
        if dictionary.isEmpty {
            completionHandler(nil, nil, true)
            return
        }
        
        let networkManager = NetworkManager<CouchDTO>()
        let urlRequest = networkManager.makeRequest(from: dictionary, url: URL(string: baseUrl + couchesUrl + "/\(id)")!, method: .PATCH)
        
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
                self.logger.debug("Couch updated with id: \(id)")
                completionHandler(self.convertDTOToModel(dto: data!), message, true)
            }
            
        }
    }
    
    func saveCouch(myCouch: Couch, completionHandler: @escaping (_ couch: Couch?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<CouchDTO>()
        let saveCouchDTO = convertModelToDTO(model: myCouch)
        saveCouchDTO.location.city = "ad"
        let urlRequest = networkManager.makeRequest(from: saveCouchDTO, url: URL(string: baseUrl + couchesUrl + "/")!, method: .POST)
        
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
                        case 409:
                            message = NSLocalizedString("networkError.couchAlreadyExists", comment: "Already exists")
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
                self.logger.debug("Couch saved with id: \(data!.id!)")
                completionHandler(self.convertDTOToModel(dto: data!), message, true)
            }
            
        }
    }
    
    func downloadImage(couchId: Int, imageId: Int, completionHandler: @escaping (_ image: CouchPhoto?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<FileDownloadDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + couchesUrl + "/\(couchId)/images/\(imageId)")!, method: .GET)
        
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
                            message = NSLocalizedString("networkError.userNotFound", comment: "CouchPhoto not found")
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
                self.logger.debug("CouchPhoto loadeded with id: \(data!.imageId)")
                
                let photo = CouchPhoto(id: data!.imageId, uiImage: UIImage(data: data!.content)!)
                completionHandler(photo, message, true)
            }
            
        }
    }
    
    func deleteImages(couchId: Int, imageIds: [Int], completionHandler: @escaping (_ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<MessageDTO>()
        let filesToDeleteDTO = FilesToDeleteDTO(ids: imageIds)
        let urlRequest = networkManager.makeRequest(from: filesToDeleteDTO, url: URL(string: baseUrl + couchesUrl + "/\(couchId)/images/")!, method: .DELETE)
        
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
                        case 403:
                            message = NSLocalizedString("networkError.forbidden", comment: "Forbidden")
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
                self.logger.debug("Message from server: \(data!.message)")
                completionHandler(message, true)
            }
            
        }
    }
    
    func uploadImages(couchId: Int, images: [CouchPhoto], completionHandler: @escaping (_ fileUploads: [FileUpload]?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let boundary = UUID().uuidString
        let networkManager = NetworkManager<[FileUploadDTO]>(requestHandler: UploadRequestHandler(boundary: boundary))
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + couchesUrl + "/\(couchId)/images/")!, method: .POST)
        
        var data = Data()
        var numberOfBigImages = 0
        
        for image in images {
            if let compressedImage = compressImage(image: image.uiImage) {
                data.append("--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(image.fileName)\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                data.append(compressedImage)
                data.append("\r\n".data(using: .utf8)!)
            } else {
                numberOfBigImages += 1
            }
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        if numberOfBigImages == images.count {
            completionHandler([FileUpload](), "Images are too big.", true)
            return
        }
        
        networkManager.uploadTask(data: data, boundary: boundary, with: urlRequest) { (networkStatus, data, error) in
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
                        case 403:
                            message = NSLocalizedString("networkError.forbidden", comment: "Forbidden")
                        case 404:
                            message = NSLocalizedString("networkError.couchNotFound", comment: "Couch not found")
                        case 422:
                            message = NSLocalizedString("networkError.wrongFile", comment: "Wrong file")
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
                self.logger.debug("CouchPhotos loaded. Count: \(data!.count)")
                
                var fileUploads = [FileUpload]()
                for fileUpload in data! {
                    fileUploads.append(FileUpload(fileName: fileUpload.name, couchPhotoId: fileUpload.id))
                }
                
                if numberOfBigImages != 0 {
                    message = "Some of the images are big."
                }
                
                completionHandler(fileUploads, message, true)
            }
            
        }
    }
    
    func compressImage(image: UIImage) -> Data? {
        var compressionQuality: CGFloat = 1.0
        let maxSize: Double = 2.0
        
        var compressedImage: Data
        var sizeInMB: Double
        
        repeat {
            compressedImage = image.jpegData(compressionQuality: compressionQuality)!
            let imageSize: Double = Double(compressedImage.count)
            sizeInMB = Double(imageSize) / 1024 / 1024;
            
            if compressionQuality < 0.01 {
                break
            }
            
            compressionQuality -= 0.2
            
        } while sizeInMB > maxSize
        
        return sizeInMB > maxSize ? nil : compressedImage
    }
    
    private func convertModelToDTO(model: Couch) -> CouchDTO {
        let numberOfRooms = Int(model.numberOfRooms) ?? 0
        let numberOfGuests = Int(model.numberOfGuests) ?? 0
        let price = Double(model.price) ?? 0.0
        
        let location = LocationDTO(city: model.city)
        
        let couchDTO = CouchDTO(name: model.name, numberOfRooms: numberOfRooms, numberOfGuests: numberOfGuests, price: price, location: location)
        
        couchDTO.id = model.id
        couchDTO.location.zipCode = model.zipCode
        couchDTO.location.city = model.city
        couchDTO.location.street = model.street
        couchDTO.location.buildingNumber = model.buildingNumber
        couchDTO.amenities = model.amenities
        couchDTO.about = model.about
        
        return couchDTO
    }
    
    private func convertDTOToModel(dto: CouchDTO) -> Couch {
        var couch = Couch()
        
        couch.id = dto.id
        couch.zipCode = dto.location.zipCode ?? ""
        couch.city = dto.location.city
        couch.street = dto.location.street ?? ""
        couch.buildingNumber = dto.location.buildingNumber ?? ""
        couch.name = dto.name
        couch.numberOfRooms = String(dto.numberOfRooms)
        couch.numberOfGuests = String(dto.numberOfGuests)
        couch.amenities = dto.amenities ?? ""
        couch.price = String(dto.price)
        couch.about = dto.about ?? ""
        couch.couchPhotoIds = dto.couchPhotoIds
        
        return couch
    }
    
    private func convertModelToDictionary(model: Couch, savedModel: Couch?) -> [String: Any?] {
        var couchDictionary = [String: Any?]()
        
        guard let unwrappedSavedModel = savedModel else {
            return couchDictionary
        }
        
        if model.name != unwrappedSavedModel.name {
            let name = model.name.isEmpty ? nil : model.name
            couchDictionary.updateValue(name, forKey: CouchDTO.CodingKeys.name.rawValue)
        }
        
        if model.numberOfGuests != unwrappedSavedModel.numberOfGuests {
            let numberOfGuests = model.numberOfGuests.isEmpty ? nil : model.numberOfGuests
            couchDictionary.updateValue(numberOfGuests, forKey: CouchDTO.CodingKeys.numberOfGuests.rawValue)
        }
        
        if model.numberOfRooms != unwrappedSavedModel.numberOfRooms {
            let numberOfRooms = model.numberOfRooms.isEmpty ? nil : model.numberOfRooms
            couchDictionary.updateValue(numberOfRooms, forKey: CouchDTO.CodingKeys.numberOfRooms.rawValue)
        }
        
        if model.about != unwrappedSavedModel.about {
            couchDictionary.updateValue(model.about, forKey: CouchDTO.CodingKeys.about.rawValue)
        }
        
        if model.amenities != unwrappedSavedModel.amenities {
            couchDictionary.updateValue(model.amenities, forKey: CouchDTO.CodingKeys.amenities.rawValue)
        }
        
        if model.price != unwrappedSavedModel.price {
            let price = model.price.isEmpty ? nil : model.price
            couchDictionary.updateValue(price, forKey: CouchDTO.CodingKeys.price.rawValue)
        }
        
        var locationDictionary = [String: Any?]()
        
        if model.city != unwrappedSavedModel.city {
            let city = model.city.isEmpty ? nil : model.city
            locationDictionary.updateValue(city, forKey: LocationDTO.CodingKeys.city.rawValue)
        }
        
        if model.zipCode != unwrappedSavedModel.zipCode {
            locationDictionary.updateValue(model.zipCode, forKey: LocationDTO.CodingKeys.zipCode.rawValue)
        }
        
        if model.street != unwrappedSavedModel.street {
            locationDictionary.updateValue(model.street, forKey: LocationDTO.CodingKeys.street.rawValue)
        }
        
        if model.buildingNumber != unwrappedSavedModel.buildingNumber {
            locationDictionary.updateValue(model.buildingNumber, forKey: LocationDTO.CodingKeys.buildingNumber.rawValue)
        }
        
        if !locationDictionary.isEmpty {
            couchDictionary.updateValue(locationDictionary, forKey: CouchDTO.CodingKeys.location.rawValue)
        }
        
        return couchDictionary
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
