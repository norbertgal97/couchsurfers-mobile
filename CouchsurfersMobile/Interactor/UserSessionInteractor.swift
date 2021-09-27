//
//  SignInInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 27..
//

import Foundation
import os

class UserSessionInteractor {
    
    private let baseUrl: String
    private let loginUrl = "users/session/login"
    private let registerUrl = "users/session/register"
    private let logoutUrl = "users/session/logout"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func signInUser(signInDetails: SignInDetails, completionHandler: @escaping (_ loggedIn: Bool, _ messsage: String?) -> Void) {
        let loginRequest = LoginRequestDTO(email: signInDetails.emailAddress, password: signInDetails.password)
        let networkManager = NetworkManager<LoginResponseDTO>()
        let urlRequest = networkManager.makeRequest(from: loginRequest, url: URL(string: baseUrl + loginUrl)!, method: .POST)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedError = error {
                    if let unwrappedStatusCode = statusCode {
                        switch unwrappedStatusCode {
                        case 400:
                            message = NSLocalizedString("networkError.badCredentials", comment: "Bad credentials")
                        default:
                            message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(false, message)
            case .successful:
                self.logger.debug("User logged in with id: \(data!.userId)")
                completionHandler(true, message)
            }
            
        }
    }
    
    func signUpUser(signUpDetails: SignUpDetails, completionHandler: @escaping (_ userCreated: Bool, _ messsage: String?) -> Void) {
        let signUpRequest = SignUpRequestDTO(email: signUpDetails.emailAddress, password: signUpDetails.password, fullName: signUpDetails.fullName)
        let networkManager = NetworkManager<SignUpResponseDTO>()
        let urlRequest = networkManager.makeRequest(from: signUpRequest, url: URL(string: baseUrl + registerUrl)!, method: .POST)
        
        networkManager.dataTask(with: urlRequest) { (networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedError = error {
                    if let unwrappedStatusCode = statusCode {
                        switch unwrappedStatusCode {
                        case 409:
                            message = NSLocalizedString("networkError.alreadyRegistered", comment: "Already registered")
                        default:
                            message = NSLocalizedString("networkError.unknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode)
                }
                
                completionHandler(false, message)
            case .successful:
                self.logger.debug("User created with id: \(data!.userId)")
                message = NSLocalizedString("authenticationNetwork.userCreated", comment: "User created")
                completionHandler(true, message)
            }
            
        }
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
