//
//  MyCouchViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 02..
//

import Foundation

class MyCouchViewModel: ObservableObject {
    @Published var hostedCouch = HostedCouch()
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknownError", comment: "Default alert message")
    @Published var showingAlert = false
    @Published var isShowingUserReservationsListView = false
    @Published var isShowingReviewsListView = false
    
    private var hostInteractor = HostInteractor()
    
    func getOwnHostedCouch(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        hostInteractor.getOwnHostedCouch { couch, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedCouch = couch {
                DispatchQueue.main.async {
                    self.hostedCouch = unwrappedCouch
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func hostCouch(completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        guard let id = hostedCouch.id else {
            completionHandler(true)
            return
        }
        
        hostInteractor.hostCouch(couchId: id, hosted: !hostedCouch.hosted) { hosted, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedHosted = hosted {
                DispatchQueue.main.async {
                    self.hostedCouch.hosted = unwrappedHosted
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
}
