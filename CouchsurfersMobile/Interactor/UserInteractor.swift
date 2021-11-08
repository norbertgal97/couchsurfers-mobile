//
//  UserInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 25..
//

import UIKit
import os

class UserInteractor: UnmanagedErrorHandler {
    private let baseUrl: String
    private let personalInformationUrl = "/api/v1/users/personal-information"
    private let usersUrl = "/api/v1/users"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func loadPersonalInformation(completionHandler: @escaping (_ personalInformation: PersonalInformation?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<PersonalInformationDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + personalInformationUrl)!, method: .GET)
        
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
                            message = NSLocalizedString("NetworkError.PersonalInformation", comment: "Personal information not found")
                        default:
                            message = NSLocalizedString("NetworkError.UnknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode, logger: self.logger)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("Personal information is loaded.")
                completionHandler(self.convertPersonalInformationDTOToModel(dto: data!), message, true)
            }
        }
    }
    
    func updatePersonalInformation(with id: Int,
                                   _ personalInformation: PersonalInformation,
                                   completionHandler: @escaping (_ personalInformation: PersonalInformation?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<PersonalInformationDTO>()
        
        let personalInformationDTO = PersonalInformationDTO(id: id, fullName: personalInformation.fullName, phoneNumber: personalInformation.phoneNumber, email: personalInformation.email)
        let urlRequest = networkManager.makeRequest(from: personalInformationDTO, url: URL(string: baseUrl + personalInformationUrl + "/\(id)")!, method: .PATCH)
        
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
                        case 403:
                            message = NSLocalizedString("NetworkError.Forbidden", comment: "Forbidden")
                        case 422:
                            message = NSLocalizedString("NetworkError.EmptyFields", comment: "Empty fields")
                        default:
                            message = NSLocalizedString("NetworkError.UnknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode, logger: self.logger)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("Personal information updated with id: \(id)")
                completionHandler(self.convertPersonalInformationDTOToModel(dto: data!), message, true)
            }
        }
    }
    
    func loadProfileData(completionHandler: @escaping (_ profileData: ProfileData?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<ProfileDataDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + usersUrl + "/profile-data/")!, method: .GET)
        
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
                        default:
                            message = NSLocalizedString("NetworkError.UnknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode, logger: self.logger)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("Profile data is loaded.")
                completionHandler(self.convertProfileDataDTOToModel(dto: data!), message, true)
            }
        }
    }
    
    func uploadImage(image: UserPhoto, completionHandler: @escaping (_ imageUpload: UserPhoto?, _ message: String?, _ loggedIn: Bool) -> Void) {
        let boundary = UUID().uuidString
        let networkManager = NetworkManager<UserPhotoDTO>(requestHandler: UploadRequestHandler(boundary: boundary))
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + usersUrl + "/images/")!, method: .POST)
        
        var data = Data()
        var isImageBig = false
        
        if let unwrappeduiImage = image.uiImage, let compressedImage = compressImage(image: unwrappeduiImage) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(image.fileName)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(compressedImage)
            data.append("\r\n".data(using: .utf8)!)
        } else {
            isImageBig = true
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        if isImageBig {
            completionHandler(UserPhoto(), "Image is too big.", true)
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
                        case 422:
                            message = NSLocalizedString("NetworkError.WrongFile", comment: "Wrong file")
                        default:
                            message = NSLocalizedString("NetworkError.UnknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode, logger: self.logger)
                }
                
                completionHandler(nil, message, true)
            case .successful:
                self.logger.debug("UserPhoto is loaded with id: \(data!.id)")
                
                if isImageBig {
                    message = NSLocalizedString("NetworkError.BigImage", comment: "Big image")
                }
                
                completionHandler(self.convertUserPhotoDTOToUserPhotoModel(dto: data!), message, true)
            }
        }
    }
    
    func deleteImage(imageId: Int, completionHandler: @escaping (_ message: String?, _ loggedIn: Bool) -> Void) {
        let networkManager = NetworkManager<MessageDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + usersUrl + "/images/\(imageId)")!, method: .DELETE)
        
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
                            message = NSLocalizedString("NetworkError.Forbidden", comment: "Forbidden")
                        default:
                            message = NSLocalizedString("NetworkError.UnknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode, logger: self.logger)
                }
                
                completionHandler(message, true)
            case .successful:
                self.logger.debug("Message from server: \(data!.message)")
                completionHandler(message, true)
            }
        }
    }
    
    private func convertUserPhotoDTOToUserPhotoModel(dto: UserPhotoDTO) -> UserPhoto {
        var userPhoto = UserPhoto()
        
        userPhoto.id = dto.id
        userPhoto.fileName = dto.fileName
        userPhoto.url = dto.url
        userPhoto.uiImage = nil
        
        return userPhoto
    }
    
    private func convertPersonalInformationDTOToModel(dto: PersonalInformationDTO) -> PersonalInformation {
        var personalInformation = PersonalInformation(id: dto.id)
        
        personalInformation.fullName = dto.fullName
        personalInformation.email = dto.email
        personalInformation.phoneNumber = dto.phoneNumber ?? ""
        
        if let userPhoto = dto.userPhoto {
            var newUserPhoto = UserPhoto()
            newUserPhoto.id = userPhoto.id
            newUserPhoto.fileName = userPhoto.fileName
            newUserPhoto.url = userPhoto.url
            
            personalInformation.userPhoto = newUserPhoto
        }
        
        return personalInformation
    }
    
    private func convertProfileDataDTOToModel(dto: ProfileDataDTO) -> ProfileData {
        var profileData = ProfileData()
        
        profileData.fullName = dto.fullName
        
        if let userPhoto = dto.userPhoto {
            var newUserPhoto = UserPhoto()
            newUserPhoto.id = userPhoto.id
            newUserPhoto.fileName = userPhoto.fileName
            newUserPhoto.url = userPhoto.url
            
            profileData.userPhoto = newUserPhoto
        }
        
        return profileData
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
    
}
