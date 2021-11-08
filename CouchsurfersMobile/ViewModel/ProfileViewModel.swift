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
    
    private var userInteractor = UserInteractor()
    private var sessionInteractor = UserSessionInteractor()
    
    func loadProfileData(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        userInteractor.loadProfileData { profileData, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
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
    
    func logout(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        sessionInteractor.logout { message in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
                
                completionHandler(true)
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(false)
            }
        }
    }
    
}
