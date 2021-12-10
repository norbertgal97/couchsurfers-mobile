//
//  ReservationDetailsViewModel.swift
//  CouchsurfersMobile
//
//  Created by Norbert Gál on 2021. 10. 23..
//

import Foundation

class ReservationDetailsViewModel: ReversePlaceIdProtocol {
    @Published var reservation: Reservation?
    @Published var description = ""
    
    @Published var alertTitle = NSLocalizedString("CommonView.Info", comment: "Information")
    @Published var alertDescription: String = NSLocalizedString("CommonView.UnknownError", comment: "Default alert message")
    @Published var showingAlert = false
    
    @Published var isShowingReviewsListView = false

    private var reservationInteractor = ReservationInteractor()
    private var reviewInteractor = ReviewInteractor()
    
    func loadReservationDetails(with id: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        reservationInteractor.loadReservationDetails(with: id) { reservation, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertTitle = NSLocalizedString("CommonView.Error", comment: "Error")
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
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
    
    func cancelReservation(with id: Int, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        reservationInteractor.cancelReservation(with: id) { message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertTitle = NSLocalizedString("CommonView.Error", comment: "Error")
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
    
    func createReview(with couchId: Int, description: String, completionHandler: @escaping (_ loggedIn: Bool) -> Void) {
        reviewInteractor.createReview(with: couchId, description) { created, message, loggedIn in
            if let unwrappedMessage = message {
                DispatchQueue.main.async {
                    self.alertDescription = unwrappedMessage
                    self.showingAlert = true
                }
            }
            
            if created {
                DispatchQueue.main.async {
                    self.alertTitle = NSLocalizedString("CommonView.Info", comment: "Information")
                    self.alertDescription = NSLocalizedString("ReservationDetailsViewModel.ReviewCreated", comment: "Review created")
                    self.showingAlert = true
                    self.description = ""
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(loggedIn)
            }
        }
    }
}
