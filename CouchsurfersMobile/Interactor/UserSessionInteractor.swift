//
//  SignInInteractor.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 27..
//

import Foundation
import os

class UserSessionInteractor: UnmanagedErrorHandler {
    private let baseUrl: String
    private let loginUrl = "/api/v1/users/session/login"
    private let registerUrl = "/api/v1/users/session/register"
    private let logoutUrl = "/api/v1/users/session/logout"
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
                        case 401:
                            message = NSLocalizedString("NetworkError.BadCredentials", comment: "Bad credentials")
                        default:
                            message = NSLocalizedString("NetworkError.UnknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode, logger: self.logger)
                }
                
                completionHandler(false, message)
            case .successful:
                self.logger.debug("User logged in with id: \(data!.userId)")
                
                var cookieDict = [String : AnyObject]()
                
                for cookie in HTTPCookieStorage.shared.cookies(for: NSURL(string: self.baseUrl)! as URL)! {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
                
                UserDefaults.standard.set(cookieDict, forKey: "savedCookies")
                
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
                            message = NSLocalizedString("NetworkError.AlreadyRegistered", comment: "Already registered")
                        default:
                            message = NSLocalizedString("NetworkError.UnknownError", comment: "Unknown error")
                        }
                        self.logger.debug("Error message from server: \(unwrappedError.errorMessage)")
                    }
                } else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode, logger: self.logger)
                }
                
                completionHandler(false, message)
            case .successful:
                self.logger.debug("User created with id: \(data!.userId)")
                message = NSLocalizedString("NetworkStatus.UserCreated", comment: "User created")
                completionHandler(true, message)
            }
        }
    }
    
    func logout(completionHandler: @escaping (_ messsage: String?) -> Void) {
        let networkManager = NetworkManager<MessageDTO>()
        let urlRequest = networkManager.makeRequest(url: URL(string: baseUrl + logoutUrl)!, method: .POST)
        
        networkManager.dataTask(with: urlRequest) {(networkStatus, data, error) in
            var message: String?
            
            switch networkStatus {
            case .failure(let statusCode):
                guard let _ = error  else {
                    message = self.handleUnmanagedErrors(statusCode: statusCode, logger: self.logger)
                    completionHandler(message)
                    return
                }
            case .successful:
                self.logger.debug("\(data!.message)")
                completionHandler(message)
            }
        }
    }
}
