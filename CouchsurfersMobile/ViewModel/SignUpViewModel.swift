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
    
    private let interactor = UserSessionInteractor()
    
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
        
        interactor.signUpUser(signUpDetails: signUpDetails) { userCreated, messsage in
            if let unwrappedMesssage = messsage {
                if userCreated {
                    DispatchQueue.main.async {
                        self.updateAlert(with: unwrappedMesssage, title: NSLocalizedString("authenticationView.info", comment: "Information"))
                    }
                } else {
                    DispatchQueue.main.async {
                        self.updateAlert(with: unwrappedMesssage, title: NSLocalizedString("authenticationView.error", comment: "Error"))
                    }
                }
            }
        }
        
    }
    
    private func updateAlert(with message: String, title: String) {
        self.alertTitle = title
        self.alertDescription = message
        self.showingAlert = true
    }
}
