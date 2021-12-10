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
    @Published var alertTitle = NSLocalizedString("CommonView.Info", comment: "Information")
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknownError", comment: "Default alert message")
    
    private let interactor = UserSessionInteractor()
    
    func createNewUser() {
        if signUpDetails.emailAddress.isEmpty || signUpDetails.password.isEmpty || signUpDetails.fullName.isEmpty {
            alertTitle = NSLocalizedString("CommonView.Error", comment: "Error")
            alertDescription = NSLocalizedString("SignUpViewModel.EmptyFieldsWarning", comment: "Empty fields")
            showingAlert = true
            return
        }
        
        if signUpDetails.password.count < 6 {
            alertTitle = NSLocalizedString("CommonView.Error", comment: "Error")
            alertDescription = NSLocalizedString("SignUpViewModel.ShortPassword", comment: "Short password")
            showingAlert = true
            return
        }
        
        if signUpDetails.password != signUpDetails.confirmedPassword {
            alertTitle = NSLocalizedString("CommonView.Error", comment: "Error")
            alertDescription = NSLocalizedString("SignUpViewModel.PasswordsDoNotMatch", comment: "Passwords do not match")
            showingAlert = true
            return
        }
        
        interactor.signUpUser(signUpDetails: signUpDetails) { userCreated, messsage in
            if let unwrappedMesssage = messsage {
                if userCreated {
                    DispatchQueue.main.async {
                        self.alertTitle = NSLocalizedString("CommonView.Info", comment: "Information")
                        self.alertDescription = unwrappedMesssage
                        self.showingAlert = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertTitle = NSLocalizedString("CommonView.Error", comment: "Error")
                        self.alertDescription = unwrappedMesssage
                        self.showingAlert = true
                    }
                }
            }
        }
    }
}
