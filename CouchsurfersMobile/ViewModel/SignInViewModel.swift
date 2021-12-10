//
//  SignInViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 09. 11..
//

import Foundation

class SignInViewModel: ObservableObject {
    @Published var signInDetails = SignInDetails()
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknownError", comment: "Default alert message")
    @Published var showingAlert = false
    
    private let interactor = UserSessionInteractor()
    
    func signInUser(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        if signInDetails.emailAddress.isEmpty || signInDetails.password.isEmpty {
            self.alertDescription = NSLocalizedString("SignInViewModel.EmptyFields", comment: "Empty fields")
            self.showingAlert = true
            
            completionHandler(false)
            return
        }
        
        interactor.signInUser(signInDetails: signInDetails) { loggedIn, messsage in
            if let unwrappedMessage = messsage {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            completionHandler(loggedIn)
        }
    }
}
