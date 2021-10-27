//
//  ProfileViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 27..
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profileData = ProfileData()
    
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false
    
    private var interactor = UserInteractor()
    
    func loadProfileData(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        interactor.loadProfileData { profileData, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedProfileData = profileData {
                DispatchQueue.main.async {
                    self.profileData = unwrappedProfileData
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
            
        }
        
    }
    
    private func updateAlert(with message: String) {
        self.alertDescription = message
        self.showingAlert = true
    }
    
}
