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
    
    private let interactor = UserSessionInteractor()
    
    func signInUser(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        if signInDetails.emailAddress.isEmpty || signInDetails.password.isEmpty {
            updateAlert(with: NSLocalizedString("authenticationNetwork.emptyFields", comment: "Empty fields"))
            completionHandler(false)
            return
        }
        
        interactor.signInUser(signInDetails: signInDetails) { loggedIn, messsage in
            if let unwrappedMessage = messsage {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            completionHandler(loggedIn)
        }
    }
    
    private func updateAlert(with message: String) {
        self.alertDescription = message
        self.showingAlert = true
    }
    
}
