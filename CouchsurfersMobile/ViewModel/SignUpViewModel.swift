//
//  SignUpViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var signUpDetails = SignUpDetails()
    @Published var showingAlert = false
    @Published var alertTitle = NSLocalizedString("authenticationView.info", comment: "Information")
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    
    private let baseUrl: String
    private let registerUrl = "users/session/register"
    
    init() {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError()
        }
        
        self.baseUrl = url
    }
    
    func createNewUser() {
        if signUpDetails.emailAddress.isEmpty || signUpDetails.password.isEmpty || signUpDetails.fullName.isEmpty {
            updateAlert(with: NSLocalizedString("authenticationNetwork.emptyFields", comment: "Empty fields"), title: NSLocalizedString("authenticationView.error", comment: "Error"))
            return
        }
        
        if signUpDetails.password.count < 6 {
            updateAlert(with: NSLocalizedString("authenticationNetwork.shortPassword", comment: "Short password"), title: NSLocalizedString("authenticationView.error", comment: "Error"))
            return
        }
        
        if signUpDetails.password != signUpDetails.confirmedPassword {
            updateAlert(with: NSLocalizedString("authenticationNetwork.passwordsDoNotMatch", comment: "Passwords do not match"), title: NSLocalizedString("authenticationView.error", comment: "Error"))
            return
        }
        
        let signUpRequest = SignUpRequestDTO(email: signUpDetails.emailAddress, password: signUpDetails.password, fullName: signUpDetails.fullName)
        let signUpEndpoint = Endpoint<SignUpRequestDTO, SignUpResponseDTO>(url: URL(string: baseUrl + registerUrl)!, method: .POST)
        
        APIHandler(endpoint: signUpEndpoint).loadData(with: signUpRequest) { (networkStatus, data, error) in
            
            switch networkStatus {
            case .failure(let statusCode):
                if let unwrappedStatusCode = statusCode {
                    print("statusCode: \(unwrappedStatusCode)")
                    self.handleStatusCode(statusCode: unwrappedStatusCode, with: error)
                }
            case .successful:
                print("User created with ID: \(data?.userId ?? -1)")
                self.updateAlert(with: NSLocalizedString("authenticationNetwork.userCreated", comment: "User created"), title: NSLocalizedString("authenticationView.info", comment: "Information"))
            }
            
        }
    }
    
    private func handleStatusCode(statusCode: Int, with error: ErrorDTO?) {
        switch statusCode {
        case 409:
            if let unwrappedError = error {
                updateAlert(with: NSLocalizedString("networkError.alreadyRegistered", comment: "Already registered"), title: NSLocalizedString("authenticationView.error", comment: "Error"))
                print("Error happened. Message: \(unwrappedError.errorMessage). Code: \(unwrappedError.errorCode)")
            } else {
                updateAlert(with: NSLocalizedString("networkError.unknownError", comment: "Unknown error"), title: NSLocalizedString("authenticationView.error", comment: "Error"))
            }
        default:
            updateAlert(with: NSLocalizedString("networkError.unknownError", comment: "Unknown error"), title: NSLocalizedString("authenticationView.error", comment: "Error"))
        }
    }
    
    private func updateAlert(with message: String, title: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertDescription = message
            self.showingAlert = true
        }
    }
}
