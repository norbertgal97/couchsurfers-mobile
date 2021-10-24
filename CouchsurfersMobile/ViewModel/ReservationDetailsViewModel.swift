//
//  ReservationDetailsViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 23..
//

import SwiftUI

class ReservationDetailsViewModel: ReversePlaceIdProtocol {
    @Published var reservation: Reservation?
    
    @Published var alertDescription: String = NSLocalizedString("defaultAlertMessage", comment: "Default alert message")
    @Published var showingAlert = false

    private var reservationInteractor = ReservationInteractor()
    
    func loadReservationDetails(with id: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        reservationInteractor.loadReservationDetails(with: id) { reservation, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.updateAlert(with: unwrappedMessage)
                }
            }
            
            if let unwrappedReservation = reservation {
                DispatchQueue.main.async {
                    self.reservation = unwrappedReservation
                    
                    self.reverseCity(cityId: unwrappedReservation.city) { reversedCity in
                        self.reservation?.city = reversedCity
                    }
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
