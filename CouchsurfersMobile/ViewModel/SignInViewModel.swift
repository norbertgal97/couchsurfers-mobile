//
//  SignInViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import Foundation

class SignInViewModel: ObservableObject {
    @Published var signInDetails = SignInDetails()
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false
    
    let baseUrl: String
    let loginUrl = "users/session/login"
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func signInUser(completionHandler: @escaping (Bool, String?) -> Void) {
        if signInDetails.emailAddress.isEmpty || signInDetails.password.isEmpty {
            updateAlert(with: NSLocalizedString("authenticationNetwork.emptyFields", comment: "Empty fields"))
            completionHandler(false, nil)
            return
        }
        
        let loginRequest = LoginRequestDTO(email: signInDetails.emailAddress, password: signInDetails.password)
        let loginEndpoint = LoginEndpoint(url: URL(string: baseUrl + loginUrl)!, method: .POST)
        
        APIHandler(endpoint: loginEndpoint).loadData(with: loginRequest) { (networkStatus, data, error) in
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    print("statusCode: \(unwrappedStatusCode)")
                    self.handleStatusCode(statusCode: unwrappedStatusCode, with: error)
                }
                
                completionHandler(false, nil)
            case .successful:
                if let sessionId = data?.sessionId {
                    completionHandler(true, sessionId)
                } else {
                    completionHandler(false, nil)
                }
            }
            
        }
    }
    
    private func handleStatusCode(statusCode: Int, with error: ErrorDTO?) {
        switch statusCode {
        case 400:
            if let unwrappedError = error {
                updateAlert(with: NSLocalizedString("networkError.badCredentials", comment: "Bad credentials"))
                print("Error happened. Message: \(unwrappedError.errorMessage). Code: \(unwrappedError.errorCode)")
            } else {
                updateAlert(with: NSLocalizedString("networkError.unknownError", comment: "Unknown error"))
            }
        default:
            updateAlert(with: NSLocalizedString("networkError.unknownError", comment: "Unknown error"))
        }
    }
    
    private func updateAlert(with message: String) {
        DispatchQueue.main.async {
            self.alertDescription = message
            self.showingAlert = true
        }
    }
    
}
