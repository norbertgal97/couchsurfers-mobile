//
//  CouchDetailsViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 14..
//

import SwiftUI

class CouchDetailsViewModel: ReversePlaceIdProtocol {
    @Published var couch = Couch()
    
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknowError", comment: "Default alert message")
    @Published var showingAlert = false
    
    @Published var reserved = false
    @Published var isShowingReviewsListView = false
    
    private var couchInteractor = CouchInteractor()
    private var reservationInteractor = ReservationInteractor()
    
    func loadCouch(with id: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        couchInteractor.loadCouch(with: id) { couch, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedCouch = couch {
                DispatchQueue.main.async {
                    self.couch = unwrappedCouch
                    
                    self.reverseCity(cityId: self.couch.city) { reversedCity in
                        self.couch.city = reversedCity
                    }
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func reserveCouch(with id: Int, _ filter: CouchFilter, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        reservationInteractor.reserveCouch(filter, couchId: id) { reserved, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if let unwrappedReserved = reserved {
                DispatchQueue.main.async {
                    self.reserved = unwrappedReserved
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
}
